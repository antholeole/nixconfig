{
  description = "Anthony's NixOS configuration";

  inputs = {
    # BEGIN NIXPKGS VARIANTS
    # main nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # bleeding edge
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # my fork for upstreaming
    oleina-nixpkgs.url = "github:antholeole/nixpkgs/4DF9FBC6E978AB2E6C80C75F3A7BE89BD8805816";

    # nixpkgs for specific packages
    # need to pin hyprland to an old version
    nixpkgs-with-vsc.url = "github:nixos/nixpkgs/24.05";
    # TODO: pin vscode version
    # END NIXPKGS VARIANTS

    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    hyprland.url = "github:hyprwm/Hyprland";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # the lastest commit works for the newer versions of vsc, but we're
    # pinned to an old version so pin this to an old one too.
    nix-riced-vscode.url = "github:antholeole/nix-rice-vscode/f5d6c1c638dd5b6b056678d571827073f3f15f02";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    zjstatus.url = "github:dj95/zjstatus";
    ags.url = "github:Aylur/ags/v1";

    # theme
    gruvbox-yazi = {
      url = "github:poperigby/gruvbox-dark-yazi";
      flake = false;
    };
    nix-colors.url = "github:misterio77/nix-colors";
    gruvbox-alacritty = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };
    gruvbox-kak = {
      url = "github:andreyorst/base16-gruvbox.kak";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    apple-silicon,
    nixgl,
    zjstatus,
    nix-vscode-extensions,
    nix-index-database,
    rust-overlay,
    oleina-nixpkgs,
    nixpkgs-with-vsc,
    nix-colors,
    gruvbox-alacritty,
    flake-parts,
    treefmt-nix,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      perSystem = {
        system,
        pkgs,
        ...
      }: {
        # TODO these may be able to go into their own module
        _module.args.mkNixGLPkg = (import ./mixins/mkNixGLPkg.nix) pkgs;
        _module.args.mkWaylandElectronPkg = (import ./mixins/mkWaylandElectronPkg.nix) pkgs;

        _module.args.pkgs-oleina = import inputs.oleina-nixpkgs {inherit system;};
        _module.args.pkgs-unstable =
          import inputs.nixpkgs-unstable {inherit system;};
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            nixgl.overlay
            rust-overlay.overlays.default
            (final: prev: {
              zjstatus = zjstatus.packages.${prev.system}.default;
            })
          ];
          config = {};
        };
      };

      systems = [
        "x86_64-linux"
      ];

      imports = [
        treefmt-nix.flakeModule

        ./parts/devshell.nix
        ./parts/treefmt.nix
        ./parts/hm.nix
        # ./parts/nixos.nix
      ];
    };
}
