pkgs: sysConf:
let
  commands = with pkgs;
    {
      "nix collect garbage" = "nix-collect-garbage";
      "restart sway" =
        "${pkgs.sway}/bin/swaymsg reload && systemctl --user restart kanshi.service";
      "say hello" = "echo hello world!";
      "sshdc" = "${lib.getExe fish} -c sshdc";
    } // sysConf.dailysh;

  gum = pkgs.gum;
in pkgs.writeShellApplication {
  runtimeInputs = [ gum ];
  name = "dailysh";
  text = with pkgs.lib; ''
    #!/usr/bin/env bash

    TYPE=$(${getExe gum} choose${
      concatStrings (mapAttrsToList (key: _: " \"${key}\"") commands)
    })

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
