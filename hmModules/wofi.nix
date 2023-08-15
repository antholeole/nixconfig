{ config, pkgs, lib, sysConfig, ... }:
let
  colors = import ../theme.nix;
in
{
  programs.wofi = lib.mkIf (!sysConfig.headless) {
    enable = true;
  };
}
