{
  description = "Anthony's NixOS configuration";

  inputs = {
    polydoro.url = "github:antholeole/polypomo/main";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:antholeole/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , polydoro
    , home-manager
    , apple-silicon
    , ...
    } @ inputs:
    let
      pkgsOverride = (inputs: {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [
            (import ./scripts/shutter-save.nix).overlay
            (import ./scripts/gapp.nix).overlay
            polydoro.overlays.default
          ];
        };
      });
    in
    {
      nixosConfigurations = {
        kayak-asahi =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;

            modules = [
              pkgsOverride
              apple-silicon.nixosModules.default
              home-manager.nixosModules.home-manager
              ./hosts/kayak/configuration.nix
              ./mixins/asahi.nix
              ./mixins/hm.nix
            ];
            
            specialArgs = {
              inherit inputs;
              asahi = true;
            };
          };
      };


      # HM only configs
      homeConfigurations = {
        anthony = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          modules = [
            ./anthony.nix
          ];
        }; 
      };    
    };
}
