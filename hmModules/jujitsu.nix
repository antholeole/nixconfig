{
  lib,
  config,
  sysConfig,
  pkgs,
  pkgs-unstable,
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

    exec ${config.programs.kakoune.package}/bin/kak "$1"
  '';
in {
  programs.jujutsu = {
    enable = true;
    package = pkgs-unstable.jujutsu;

    settings = {
      user = with sysConfig; {inherit email name;};
      ui.editor = "${config.programs.kakoune.package}/bin/kak";

      signing = {
        sign-all = true;
        key = "~/.ssh/id_ed25519.pub";
      };

      git = {push-bookmark-prefix = "${sysConfig.selfAlias}/";};

      aliases = {
        signoff = ["--config-toml=ui.editor='${jjSignoff}/bin/jj-signoff'" "commit"];
      };
    };
  };

  programs.fish.shellAbbrs = let
    wantsRevFlag = {
      jjst = "jj status";
      jja = "jj amend";
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
    };
  in
    wantsRevFlag // noRevFlag // withRevFlag;
}
