{ pkgs, inputs }:
pkgs.writeShellApplication {
  name = "eww_on_focused";
  text = with pkgs.lib; ''
    #!/usr/bin/env bash

    ${getExe pkgs.python311} ${inputs.self}/scripts/eww_on_focused.py "$@"
  '';
}

