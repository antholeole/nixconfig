{
  description = "Anthony's NixOS configuration";

  inputs = {
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , agenix
    , apple-silicon
    , ...
    } @ inputs: {
      nixosModules = import ./modules { lib = nixpkgs.lib; };

      nixosConfigurations = {
        kayak-asahi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            apple-silicon.nixosModules.default
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            ./hosts/kayak/configuration.nix
          ];
          specialArgs = { inherit inputs; asahi = true; };
        };
      };
    };
}