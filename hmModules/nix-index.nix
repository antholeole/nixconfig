{inputs, ...}: {

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
  
  programs.nix-index-database = {comma.enable = true;};

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
