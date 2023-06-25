{ ... }: {
  zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish.shellAbbrs = {
    cd = "z $argv";
  };
}
