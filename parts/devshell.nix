{ ...}: {
  perSystem = {
    system,
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.packages.scripts];
      
      packages = [
      ];
    };
  };
}
