{
  description = "Anthony's NixOS configuration";

  inputs = {
    # main nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # bleeding edge
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # my fork for upstreaming
    oleina-nixpkgs.url = "github:antholeole/nixpkgs";

    # indirect; just used to pin follows packages
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
    # end indirect

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };
    
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      # inputs.rust-overlay.follows = "rust-overlay";
    };
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    hyprland = {
      # this seems to work on the glaptop. newer versions try to bump mesa (?)
      url = "github:hyprwm/Hyprland/3cba4ba44e7ba3cc8bb67ac71bc61245b5aca347";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      # inputs.rust-overlay.follows = "rust-overlay";
      inputs.crane.follows = "crane";
    };

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.rust-overlay.follows = "rust-overlay";
    };

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
    # end theme
  };

  nixConfig = {
    extra-substituters = ["https://helix.cachix.org"];
    extra-trusted-public-keys = ["helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    apple-silicon,
    nixgl,
    zjstatus,
    helix,
    nix-index-database,
    rust-overlay,
    oleina-nixpkgs,
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
              helix = helix.packages.${prev.system}.default;
              zjstatus = zjstatus.packages.${prev.system}.default;
            })
          ];
          config = {
            # terraform :(
            allowUnfree = true;
          };
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
