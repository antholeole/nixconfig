{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [
        (pkgs.symlinkJoin
          {
            name = "ags-node";
            paths = [
              inputs.ags2.packages.${system}.default
              pkgs.nodejs_23
            ];
          })
      ];
    };
  };
}
