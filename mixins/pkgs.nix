system: inputs: {
  pkgs-folu = import inputs.oleina-nixpkgs {inherit system;};
  nur = import inputs.nur {inherit system;};

  # default pkgs
  pkgs-unstable =
    import inputs.nixpkgs-unstable {inherit system;};
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      inputs.rust-overlay.overlays.default
      inputs.niri-flake.overlays.niri
    ];
    config.allowUnfree = true;
  };
}
