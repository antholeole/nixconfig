{ pkgs, inputs }:
pkgs.writeShellApplication {
  runtimeInputs = with pkgs; [ gum kakoune python311 ];
  name = "dailysh";
  # silly rounabout way of triggering a python script oopsie
  text = with pkgs.lib; ''
    #!/usr/bin/env bash

    ${getExe pkgs.python311} ${inputs.self}/scripts/notes.py --gum ${
      getExe pkgs.gum
    } --kakoune ${getExe pkgs.kakoune}
  '';
}
