{
  description = "Anthony's NixOS configuration";

  inputs = {
    # main nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs with niri that can use the mesa on all my laptops
    nixpkgs-niri.url = "github:nixos/nixpkgs/nixos-24.11";
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

    niri-flake = {
      url = "github:sodiboo/niri-flake";
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
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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

    jujutsu = {
      url = "github:jj-vcs/jj";

      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixzx = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:antholeole/nixzx";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nixGL,
    zjstatus,
    helix,
    nix-index-database,
    rust-overlay,
    oleina-nixpkgs,
    nix-colors,
    gruvbox-alacritty,
    flake-parts,
    treefmt-nix,
    jujutsu,
    niri-flake,
    nixzx,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      perSystem = {
        system,
        pkgs,
        ...
      }: {
        _module.args.pkgs-unstable =
          import inputs.nixpkgs-unstable {inherit system;};
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            nixGL.overlay
            rust-overlay.overlays.default

            niri-flake.overlays.niri
            nixzx.overlays.default

            (final: prev: let
              zx-packages = import (./programs/zx) prev;
            in
              zx-packages
              // {
                helix = helix.packages.${prev.system}.default;
                zjstatus = zjstatus.packages.${prev.system}.default;
                jujutsu = jujutsu.packages.${prev.system}.default;

                ghbrowse = (import ./programs/ghbrowse) prev;
              })
          ];
          config.allowUnfree = true;
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        treefmt-nix.flakeModule
        home-manager.flakeModules.home-manager

        ./parts/devshell.nix
        ./parts/treefmt.nix
        ./parts/nixos.nix
        ./parts/hm.nix
        ./parts/packages.nix
      ];
    };
}
