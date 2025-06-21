{...}: {
  perSystem = {
    system,
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [];
      
      packages = [

# cant use inputs from. buildNpmPackage does not work with nodejs24
pkgs.nodejs_24 
      ];
    };
  };
}
