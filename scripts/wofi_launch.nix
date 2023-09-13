pkgs: sysConf:
let
  commands = with pkgs; {
    "chrome" = "${lib.getExe chromium}";
    "alacritty (default)" = "${lib.getExe alacritty}";
    "code" = "code";
    # "alacritty (daily)" = ""
    "pavucontrol" = "${lib.getExe pavucontrol}";
  } // sysConf.wofiCmds;
in with pkgs; writeShellApplication {
  runtimeInputs = [ gum wofi ];
  name = "wofi-launch";
  text = with pkgs.lib; ''
    #!/usr/bin/env bash

    PROGRAM=$(printf "${strings.concatStringsSep "\\n" (mapAttrsToList (key: _: "${key}") commands)}" | ${getExe pkgs.wofi} --show dmenu)

    case $PROGRAM in
    ${concatStrings (mapAttrsToList (key: cmd: ''
      "${key}")
      ${cmd}
        ;;
    '') commands)}
    *)
     ${getExe fish} -c "$PROGRAM"
    ;;
    esac

    echo "$PROGRAM"
'';
}
