{
  description = "Anthony's NixOS configuration";

  inputs = {
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    devenv.url = "github:cachix/devenv";
    ags.url = "github:Aylur/ags";
    home-manager.url = "github:nix-community/home-manager/master";
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = { 
    self,
     nixpkgs,
     flake-utils,
     home-manager,
     apple-silicon,
     nixgl, 
     devenv,
     ... 
     } @ inputs:
    let
      pkgsOverride = {
        nixpkgs = {
          config.allowUnfree = true;
          overlays =
            [ (import ./scripts/shutter-save.nix).overlay nixgl.overlay ];
        };
      };

      specialArgs = confName: pkgs: rec {
        inherit inputs;

        sysConfig = (import ./conf.nix)."${confName}";


        systemCopy = (import ./mixins/mkSystemCopy.nix) sysConfig pkgs;
        mkNixGLPkg = (import ./mixins/mkNixGLPkg.nix) sysConfig pkgs;
        mkWaylandElectronPkg = (import ./mixins/mkWaylandElectronPkg.nix) pkgs;
        mkOldNixPkg = (import ./mixins/mkOldNixPkg.nix);
      };

      system = "x86_64-linux";
      mkPkgs = system: (import nixpkgs (pkgsOverride.nixpkgs // { inherit system; }));

      mkHmOnlyConfig = conf: home-manager.lib.homeManagerConfiguration rec {
          # allows us to define pkgsOverride as a module for easy consumption 
          # on nixos, but as a override for pkgs here.
          pkgs = (import nixpkgs (pkgsOverride.nixpkgs // { inherit system; }));
          modules = import ./hmModules inputs;
          extraSpecialArgs = specialArgs conf pkgs;
        };
    in {
      nixosConfigurations = {
        kayak-asahi = let system = "aarch64-linux";
        in nixpkgs.lib.nixosSystem {
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

      devShell.x86_64-linux = let 
        pkgs = mkPkgs system;
      in devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({ pkgs, config, ... }: with pkgs; {
            scripts = {
              agsdev.exec = let 
                agsExe = lib.getExe inputs.ags.packages."${system}".default;
                agsDir = "$DEVENV_ROOT/confs/ags/";
              in ''
              ${lib.getExe watchexec} -w  ${agsDir} --exts scss,js --restart -- '${lib.getExe sass} ${agsDir}style.scss:${agsDir}/style.css && ${agsExe} -c $DEVENV_ROOT/confs/ags/config.js'
              '';
            };
            packages = [ pkgs.hello ];
          })
        ];
      };
      };
}
