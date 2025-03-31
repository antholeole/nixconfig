{inputs, ...}: {
  perSystem = {
    pkgs,
    pkgs-unstable,
    pkgs-oleina,
    
    system,
    lib,
    config,
    ...
  }: {
    nixosConfigurations = {
      kayak-asahi = inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        extraSpecialArgs = {
          inherit inputs pkgs-unstable pkgs-oleina;
        };

        modules = with inputs; [
          apple-silicon.nixosModules.default
          home-manager.nixosModules.home-manager

          "${self}/hosts/kayak/configuration.nix"
          "${self}/mixins/asahi.nix"
          "${self}/mixins/hmShim.nix"

          
          (import "${inputs.self}/hmModules/configs/asahi-personal.nix")
        ] ++ (import "${inputs.self}/hmModules" inputs);
      };
    };
  };
}
