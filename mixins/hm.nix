{ inputs, ... }: {
  home-manager.users.anthony = import "${inputs.self}/anthony.nix"; 
}