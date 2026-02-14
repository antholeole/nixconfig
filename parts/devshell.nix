{...}: {
  perSystem = {
    system,
    pkgs,
    lib,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.flake-root.devShell];
    };
  };
}
