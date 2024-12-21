{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        biome.enable = true;
        mdformat.enable = true;
        gofmt.enable = true;
      };
    };
  };
}
