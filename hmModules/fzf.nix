{ pkgs, lib, sysConfig, ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # enabled in fish
  };
}