{
  lib,
  config,
  pkgs,
  ...
}: let
  # TODO move this somewhere sensible.
  jjBin = "${config.programs.jujutsu.package}/bin/jj";
  jjSignoff = pkgs.writeShellScriptBin "jj-signoff" ''
    set -euo pipefail

    NAME=$(${jjBin} config get user.name)
    MAIL=$(${jjBin} config get user.email)
    CID=$(${jjBin} log --no-graph -r @ -T "change_id" | sha256sum | head -c 40)

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
        editor = "${config.programs.helix.package}/bin/hx";
        color = "always";
        pager = {
          command = ["${pkgs.delta}/bin/delta"];
          env = {DELTA_PAGER = "${pkgs.less}/bin/less -RXF";};
        };
        diff.format = "git";
        paginate = "auto";
      };

      signing = {

behavior = "own";        key = "~/.ssh/id_ed25519.pub";
      };

      git = {push-bookmark-prefix = "${config.conf.selfAlias}/";};

      aliases = {
        signoff = ["--config-toml=ui.editor='${jjSignoff}/bin/jj-signoff'" "commit"];
        d = ["describe"];
        dm = ["describe" "-m"];
        g = ["git"];
        shas = ["log" "-r=root()..@" "-T" "author.timestamp().local().format(\'%Y-%m-%d\') ++ \" \" ++ truncate_end(72, pad_end(72, coalesce(description.first_line(), \"(no desc)\")))  ++ commit_id ++ \"\n\"" "--no-graph"];
        retrunk = ["rebase" "-d" "trunk()"];
        temp = ["new" "-m" "[TEMP]"];
      };

      revset-aliases = {
        # many of these copied from https://gist.github.com/thoughtpolice/8f2fd36ae17cd11b8e7bd93a70e31ad6.
        "trunk()" = "latest((present(main) | present(master)) & remote_bookmarks())";
        "stack()" = "ancestors(reachable(@, mutable()), 2)";
        "stack(x)" = "ancestors(reachable(x, mutable()), 2)";
        "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";
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
      jjn = "jj new";
      jjcb = {
        expansion = ''jj branch create "%" -r @-'';
        setCursor = true;
      };

      jjgp = "jj git push -c @-";
      jja = "jj abandon @ ; jj new "; # jj abandon for tmp branches
    };
  in
    wantsRevFlag // noRevFlag // withRevFlag;
}
