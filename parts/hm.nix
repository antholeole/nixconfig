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
    mkWaylandElectronPkg,
    ...
  }: let
    # some special args that some hm modules need
    hmSpecialArgs = {
      inherit inputs pkgs-unstable pkgs-oleina mkWaylandElectronPkg;

      mkNixGLPkg = (import "${inputs.self}/mixins/mkNixGLPkg.nix") pkgs;
    };
    mkHmOnlyConfig = config:
      inputs.home-manager.lib.homeManagerConfiguration {
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
      personal =  mkHmOnlyConfig "hm-personal";
    };
  };
}
