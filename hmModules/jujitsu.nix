{
  lib,
  config,
  pkgs,
  ...
}: let
  # TODO move this somewhere sensible.
  jjSignoff = pkgs.writeShellScriptBin "jj-signoff" ''
    set -euo pipefail

    NAME=$(jj config get user.name)
    MAIL=$(jj config get user.email)
    CID=$(jj log --no-graph -r @ -T "change_id" | sha256sum | head -c 40)

    SIGNSTR="Signed-off-by: ''${NAME} <''${MAIL}>"
    CHGSTR="Change-Id: I''${CID}"

    contents=$(<"$1")
    readarray -t lines <<<"''${contents}"

    body=""
    last=""
    for x in "''${lines[@]}"; do
      [[ "$x" =~ ^"JJ:" ]] && continue
      [[ "$x" =~ ^"Change-Id:" ]] && continue
      [[ "$x" =~ ^"$SIGNSTR" ]] && continue

      [[ "$x" == "" ]] && [[ "$last" == "" ]] && continue

      last="$x"
      body+="$x\n"
    done

    body+="$SIGNSTR\n"
    body+="$CHGSTR\n"

    t=$(mktemp)
    printf "$body" > "$t"
    mv "$t" "$1"

    exec ${config.programs.helix.package}/bin/hx "$1"
  '';
in {
  programs.jujutsu = {
    enable = true;

    settings = {
      user = with config.conf; {inherit email name;};
      ui = {
        # not perfect but hx depends on jj and jj depends on hx.
        # we have to break the circle somewhere
        editor = "${config.programs.helix.package}/bin/hx";
        color = "always";
        diff-formatter = ":git";
        paginate = "auto";
        pager ="less -RFX";
      };

      signing = {
        behavior = "own";
        key = "~/.ssh/id_ed25519.pub";
      };

      templates = {
        git_push_bookmark = "\"${config.conf.selfAlias}/\" ++ change_id.short()";
      };

      aliases = {
        signoff = ["--config=ui.editor='${jjSignoff}/bin/jj-signoff'" "commit"];
        d = ["describe"];
        dm = ["describe" "-m"];
        shas = ["log" "-r=root()..@" "-T" "author.timestamp().local().format(\'%Y-%m-%d\') ++ \" \" ++ truncate_end(72, pad_end(72, coalesce(description.first_line(), \"(no desc)\")))  ++ commit_id ++ \"\n\"" "--no-graph"];
        retrunk = ["rebase" "-d" "trunk()"];
        temp = ["new" "-m" "[TEMP]"];
      };

      revset.log = "present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 4)";
      revsets.log = "present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 4)";

      revset-aliases = {
        # many of these copied from https://gist.github.com/thoughtpolice/8f2fd36ae17cd11b8e7bd93a70e31ad6.
        "trunk()" = "latest((present(main) | present(master)) & remote_bookmarks())";
        "stack()" = "ancestors(reachable(@, mutable()), 2)";
        "stack(x)" = "ancestors(reachable(x, mutable()), 2)";
        "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";
      };

      merge-tools.delta = {
        program = "${pkgs.delta}/bin/delta";
        diff-expected-exit-codes = [0 1];
        diff-args = ["--file-transformation" "s,^[12]/tmp/jj-diff-[^/]*/,," "$left" "$right"];
      };

      merge-tools.mergiraf = {
        program = "${pkgs.mergiraf}/bin/mergiraf";
        merge-args = ["merge" "$base" "$left" "$right" "-o" "$output" "--fast"];
        merge-conflict-exit-codes = [1];
        conflict-marker-style = "git";
      };
    };
  };

  programs.fish.shellAbbrs = let
    wantsRevFlag = {
      jjst = "jj status";
      jjd = "jj diff";
      jjlo = "jj log";
    };

    withRevFlag =
      lib.attrsets.concatMapAttrs (abbr: command: {
        "${abbr}r" = {
          expansion = ''${command} -r "%"'';
          setCursor = true;
        };
      })
      wantsRevFlag;

    noRevFlag = {
      jjr = "jj resolve --tool mergiraf && jj resolve";
      jjn = "jj new";
      jjcb = {
        expansion = ''jj branch create "%" -r @-'';
        setCursor = true;
      };
    };
  in
    wantsRevFlag // noRevFlag // withRevFlag;
}
