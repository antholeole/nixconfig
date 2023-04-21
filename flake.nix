{
  description = "Anthony's NixOS configuration";

  inputs = {
    polypomo.url = "github:antholeole/polypomo";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:antholeole/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , polypomo
    , home-manager
    , apple-silicon
    , ...
    } @ inputs: let 
      pkgsOverride = (inputs: {
        nixpkgs = {
          config.allowUnfree = true;
            overlays = [
              polypomo.overlay
            ];
          };
        });
    in { 
      nixosConfigurations = {
        kayak-asahi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            pkgsOverride
            apple-silicon.nixosModules.default
            home-manager.nixosModules.home-manager
            ./modules/git.nix
            ./modules/code/code.nix
            ./modules/starship.nix
            ./modules/alacritty.nix
            ./modules/rofi.nix
            ./modules/polybar.nix
            ./modules/fluxbox
            ./hosts/kayak/configuration.nix
          ];
          specialArgs = { 
            inherit inputs; 
            asahi = true; 
          };
        };
      };
    };
}
