{ pkgs, ... }: {
  programs.thefuck = {
    enable = true;
    enableFishIntegration = true;
  }
}