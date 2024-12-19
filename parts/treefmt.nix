{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        biome.enable = true;
      };
    };
  };
}
