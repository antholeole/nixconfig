{ lib, sysConfig, pkgs, inputs, ... }:
{
  programs.eww = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = "${inputs.self}/confs/eww";
  };
}