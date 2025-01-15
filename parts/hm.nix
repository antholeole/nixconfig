{
  specialArgs,
  inputs,
  ...
}: {
  debug = true;
  perSystem = {
    pkgs,
    pkgs-unstable,
    pkgs-oleina,
    config,
    ...
  }: let
    # some special args that some hm modules need
    hmSpecialArgs = {
      inherit inputs pkgs-unstable pkgs-oleina;

      flake-config = config;
      mkNixGLPkg = (import "${inputs.self}/mixins/mkNixGLPkg.nix") pkgs;
      mkWaylandElectronPkg = (import "${inputs.self}/mixins/mkWaylandElectronPkg.nix") pkgs;
      mkOldNixPkg = import "${inputs.self}/mixins/mkOldNixPkg.nix";
    };
    mkHmOnlyConfig = config:
      inputs.home-manager.lib.homeManagerConfiguration rec {
        inherit pkgs;

        modules =
          (import ../hmModules inputs)
          ++ [
            (import "${inputs.self}/hmModules/configs/${config}.nix")
          ];

        extraSpecialArgs = hmSpecialArgs;
      };
  in {
    legacyPackages.homeConfigurations = {
      pc = mkHmOnlyConfig "hm-pc";
      work = mkHmOnlyConfig "hm-work";
      headless = mkHmOnlyConfig "hm-headless";
      headless-work = mkHmOnlyConfig "hm-headless-work";
      headless-gce = mkHmOnlyConfig "hm-headless-gce";
    };
  };
}
