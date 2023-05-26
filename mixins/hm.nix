{ inputs, laptop, hidpi, ... }: {
  home-manager = {
    extraSpecialArgs = {
      inherit laptop hidpi;
    };

    users.anthony = import "${inputs.self}/anthony.nix"; 
  };
}