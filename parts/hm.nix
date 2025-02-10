{inputs, ...}: {
  debug = true;
  perSystem = {
    pkgs,
    pkgs-unstable,
    pkgs-oleina,
    inputs',
    ...
  }: let
    # some special args that some hm modules need
    hmSpecialArgs = {
      inherit inputs pkgs-unstable pkgs-oleina;

      mkNixGLPkg = (import "${inputs.self}/mixins/mkNixGLPkg.nix") pkgs;
      mkWaylandElectronPkg = (import "${inputs.self}/mixins/mkWaylandElectronPkg.nix") pkgs;
      mkOldNixPkg = import "${inputs.self}/mixins/mkOldNixPkg.nix";
    };
    mkHmOnlyConfig = config:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = let
          externalModules = [inputs.dooit.homeManagerModules.default];
          hmModules = import ../hmModules inputs;
          configModule = [
            (import "${inputs.self}/hmModules/configs/${config}.nix")
          ];
        in
          externalModules
          ++ hmModules
          ++ configModule;

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
