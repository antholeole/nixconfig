{
  inputs,
  self,
  ...
}: {
  debug = true;
  perSystem = {
    pkgs,
    pkgs-unstable,
    ...
  }: let
    # some special args that some hm modules need
    hmSpecialArgs = {
      inherit inputs pkgs-unstable self;
    };
    mkHmOnlyConfig = config:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules =
          (import ../hmModules)
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
      asahi-personal = mkHmOnlyConfig "asahi-personal";
    };
  };
}
