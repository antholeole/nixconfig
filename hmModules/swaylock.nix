{ pkgs, lib, sysConfig, ... }: {
  programs.swaylock = lib.mkIf (!sysConfig.headless) {
    enable = true;
  };
}