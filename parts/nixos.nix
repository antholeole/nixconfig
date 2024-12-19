{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    nixosConfigurations = {
      kayak-asahi = inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        modules = with inputs; [
          apple-silicon.nixosModules.default
          home-manager.nixosModules.home-manager

          "${self}/hosts/kayak/configuration.nix"
          "${self}/mixins/asahi.nix"
          "${self}/mixins/hmShim.nix"
        ];
      };
    };
  };
}
