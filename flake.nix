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
            polydoro.overlays.default
            nt.overlays.default
            nixgl.overlay
          ];
        };
      };

      specialArgs = confName: {
        inherit inputs;

        sysConfig = (import ./conf.nix)."${confName}";
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

            specialArgs = (specialArgs "kayak-asahi");

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
        anthony =
          let
            system = "x86_64-linux";
          in
          home-manager.lib.homeManagerConfiguration {
            # allows us to define pkgsOverride as a module for easy consumption 
            # on nixos, but as a override for pkgs here.
            pkgs = (import nixpkgs (pkgsOverride.nixpkgs // {
              inherit system;
            }));

            modules = import ./hmModules inputs;

            extraSpecialArgs = specialArgs "hm-pc";
          };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        name = "nixconfig";
        packages = with pkgs; [
          nixfmt
        ];
      };
    });
}
