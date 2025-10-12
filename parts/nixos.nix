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
        inherit pkgs-unstable pkgs;
      };

      modules = let
        topLevelModule = {...}: {
          nixpkgs.pkgs = pkgs;
          networking.hostName = "solitude";

        };

        hmConfig = {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs pkgs-unstable pkgs self;
            };

            backupFileExtension = "bak";

            users.anthony = {pkgs, ...}: {
              imports =
                (import ../hmModules)
                ++ [../hmModules/configs/hm-pc.nix];
            };
          };
        };
      in [
        inputs.nixpkgs.nixosModules.readOnlyPkgs
        inputs.home-manager.nixosModules.home-manager
        inputs.nixpkgs.nixosModules.readOnlyPkgs
        topLevelModule

        hmConfig

        ../nixosModules/basic.nix
        ../nixosModules/niri.nix
        ../nixosModules/nvidia.nix
        ../nixosModules/steam.nix

        ../hardware/pc.nix
      ];
    });
}
