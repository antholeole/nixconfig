pkgs: sysConf:
let
  commands = {
    "nix collect garbage" = "nix-collect-garbage";
    "say hello" = "echo hello world!";
    "sshdc" = "sshdc";
  } // sysConf.dailysh;

  gum = pkgs.gum;
in
pkgs.writeShellApplication {
  runtimeInputs = [ gum ];
  name = "dailysh";
  text = with pkgs.lib; ''
    #!/usr/bin/env bash

    TYPE=$(${getExe gum} choose${concatStrings (mapAttrsToList (key: _: " \"${key}\"") commands)})

    case $TYPE in
    ${concatStrings (mapAttrsToList (key: cmd: ''
      "${key}")
      ${cmd}
        ;;
    '') commands)}
    esac

    echo '{{ Foreground "#00ff00" "Press any key to restart." }}' | gum format -t template
  '';
}
