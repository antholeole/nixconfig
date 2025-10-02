{
  config,
  inputs,
  lib,
  ...
}: {
  services.wpaperd = {
    enable = !config.conf.headless && !config.conf.darwin;
    settings = let
      config = {
        path = "${inputs.self}/confs/bgs/bg.png";
      };
    in {
      "default" = config;
    };
  };
}
