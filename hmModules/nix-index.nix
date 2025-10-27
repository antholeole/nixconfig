{inputs, ...}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index-database = {comma.enable = true;};

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
