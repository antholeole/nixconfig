{
  description = "Anthony's NixOS configuration";

  inputs = {
    polydoro.url = "github:antholeole/polypomo/main";
    nt.url = "github:antholeole/nt/main";

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:antholeole/home-manager/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs =
    { self
    , nixpkgs
    , polydoro
    , nt
    , flake-utils
    , home-manager
    , apple-silicon
    , nixgl
    , ...
    } @ inputs:
    let
      pkgsOverride = {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [
            (import ./scripts/shutter-save.nix).overlay
            (import ./scripts/gapp.nix).overlay
            (import ./scripts/sway_screenshare.nix).overlay
            polydoro.overlays.default
            nt.overlays.default
            nixgl.overlay
          ];
        };
      };

      specialArgs = confName: pkgs: rec {
        inherit inputs;

        sysConfig = (import ./conf.nix)."${confName}";

        mkNixGLPkg = (import ./mixins/mkNixGLPkg.nix) sysConfig pkgs;
        mkWaylandElectronPkg = (import ./mixins/mkWaylandElectronPkg.nix) pkgs;
      };

      mkHmOnlyConfig = conf:
        let
          system = "x86_64-linux";
        in
        home-manager.lib.homeManagerConfiguration rec {
          # allows us to define pkgsOverride as a module for easy consumption 
          # on nixos, but as a override for pkgs here.
          pkgs = (import nixpkgs (pkgsOverride.nixpkgs // {
            inherit system;
          }));

          modules = import ./hmModules inputs;

          extraSpecialArgs = specialArgs conf pkgs;
        };
    in
    {
      nixosConfigurations = {
        kayak-asahi =
          let
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
      };


    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        name = "nixconfig";
        packages = with pkgs; [
          home-manager
          nixfmt
        ];
      };
    });
}
