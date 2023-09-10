pkgs: sysConf:
let
  commands = {
    "nix collect garbage" = "nix-collect-garbage";
    "say hello" = "echo hello world!";
  } // sysConf.dailysh;

  gum = pkgs.gum;
in
pkgs.writeShellApplication {
  runtimeInputs = [ gum ];
  name = "dailysh";
  text = with pkgs.lib; ''
    #!/usr/bin/env bash

    TYPE=$(${getExe gum} choose${concatStrings (mapAttrsToList (key: _: " \"${key}\"") commands)})

    echo "$TYPE"
  '';
}
