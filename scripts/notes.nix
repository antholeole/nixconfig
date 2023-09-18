pkgs: pkgs.writeShellApplication {
  runtimeInputs = with pkgs; [ gum kakoune python ];
  name = "dailysh";
  text = with pkgs.lib; ''
        #!/usr/bin/env bash

        ${getExe pkgs.python} --gum ${getExe pkgs.gum} --kakoune ${getExe pkgs.kakoune} ${}
  '';
}
