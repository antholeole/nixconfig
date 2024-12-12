{
  description = "Anthony's NixOS configuration";

  inputs = {
    # main nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs-with-hyprland.url = "github:nixos/nixpkgs/7a339d87931bba829f68e94621536cad9132971a";

    # currently has:
    # - adds hop.kak
    oleina-nixpkgs.url = "github:antholeole/nixpkgs/4DF9FBC6E978AB2E6C80C75F3A7BE89BD8805816";

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
    rust-overlay.url = "github:oxalica/rust-overlay";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-riced-vscode.url = "github:antholeole/nix-rice-vscode/e1d069b984f502dd3d802bb486378b7f756b1ce6";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    zjstatus.url = "github:dj95/zjstatus";
    ags.url = "github:Aylur/ags";

    # theme
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-yazi = {
      url = "github:catppuccin/yazi";
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
    nixpkgs-with-hyprland,
    ...
  } @ inputs: let
    pkgsOverride = {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          rust-overlay.overlays.default
          (final: prev: {
            zjstatus = zjstatus.packages.${prev.system}.default;
          })
        ];
      };
    };

    # TODO: flake parts would make this 100x better
    specialArgs = confName: pkgs: rec {
      inherit inputs;

      sysConfig = (import ./conf.nix)."${confName}";

      systemClip = (import ./mixins/systemClip.nix) sysConfig inputs pkgs;
      mkNixGLPkg = (import ./mixins/mkNixGLPkg.nix) sysConfig pkgs;
      mkWaylandElectronPkg = (import ./mixins/mkWaylandElectronPkg.nix) pkgs;
      mkOldNixPkg = import ./mixins/mkOldNixPkg.nix;

      oleinaNixpkgs =
        import inputs.oleina-nixpkgs {system = pkgs.system;};
      pkgs-unstable =
        import inputs.nixpkgs-unstable {system = pkgs.system;};
    };

    system = "x86_64-linux";
    mkPkgs = system: (import nixpkgs (pkgsOverride.nixpkgs // {inherit system;}));

    mkHmOnlyConfig = conf:
      home-manager.lib.homeManagerConfiguration rec {
        # allows us to define pkgsOverride as a module for easy consumption
        # on nixos, but as a override for pkgs here.
        pkgs = import nixpkgs (pkgsOverride.nixpkgs // {inherit system;});
        modules = import ./hmModules inputs;
        extraSpecialArgs = specialArgs conf pkgs;
      };
  in {
    packages.${system} = {
      oleinaags = import ./confs/ags (mkPkgs system);
    };

    nixosConfigurations = {
      kayak-asahi = let
        system = "aarch64-linux";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = (specialArgs "kayak-asahi") pkgsOverride.nixpkgs;

          modules = [
            pkgsOverride

            apple-silicon.nixosModules.default
            home-manager.nixosModules.home-manager
            ./hosts/kayak/configuration.nix
            ./mixins/asahi.nix
            ./mixins/hmShim.nix
          ];
        };
    };

    # HM only configs
    homeConfigurations = {
      pc = mkHmOnlyConfig "hm-pc";
      work = mkHmOnlyConfig "hm-work";
      headless = mkHmOnlyConfig "hm-headless";
      headless-work = mkHmOnlyConfig "hm-headless-work";
      headless-gce = mkHmOnlyConfig "hm-headless-gce";
    };
  };
}
