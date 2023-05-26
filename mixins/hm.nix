{ inputs, laptop, ... }: {
  home-manager = {
    extraSpecialArgs = {
      inherit laptop;
    };

    users.anthony = import "${inputs.self}/anthony.nix"; 
  };
}