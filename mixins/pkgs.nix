system: inputs: {
  pkgs-oleina = import inputs.oleina-nixpkgs {inherit system;};
  nur = import inputs.nur {inherit system;};

  # default pkgs
  pkgs-unstable =
    import inputs.nixpkgs-unstable {inherit system;};
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      inputs.nixGL.overlay
      inputs.rust-overlay.overlays.default
      inputs.niri-flake.overlays.niri

      (final: prev: let
        zx-packages = import (../programs/zx) prev;
      in
        zx-packages
        // {
          helix = inputs.helix.packages.${prev.system}.default;
          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
          jujutsu = inputs.jujutsu.packages.${prev.system}.default;
        })
    ];
    config.allowUnfree = true;
  };
}
