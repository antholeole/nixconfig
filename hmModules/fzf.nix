{...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # enabled in fish
    defaultOptions = ["--height 20%"];
  };
}
