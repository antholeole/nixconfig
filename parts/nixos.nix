{
  inputs,
  withSystem,
  self,
  ...
}: {
  flake.nixosConfigurations.pc = withSystem "x86_64-linux" ({
    config,
    pkgs-unstable,
    pkgs,
    ...
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit pkgs-unstable;
      };

      modules = let
        hmConfig = {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs pkgs-unstable pkgs self;
            };

            backupFileExtension = "bak";

            users.folu = {pkgs, ...}: {
              imports =
                (import ../hmModules)
                ++ [../hmModules/configs/hm-pc.nix];
            };
          };
        };
      in [
        inputs.nixpkgs.nixosModules.readOnlyPkgs
        inputs.home-manager.nixosModules.home-manager

        ({
          nixpkgs.pkgs = pkgs;
          networking.hostName = "solitude";
        })

        hmConfig

        ../nixosModules/basic.nix
        ../nixosModules/niri.nix
        ../nixosModules/nvidia.nix
        ../nixosModules/steam.nix

        ../hardware/pc.nix
      ];
    });
}
