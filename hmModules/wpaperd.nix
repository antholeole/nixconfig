{
  config,
  inputs,
  ...
}: {
  services.wpaperd = {
    enable = !config.conf.headless;
    settings = let
      config = {
        path = "${inputs.self}/confs/bgs/bg.png";
      };
    in {
      "default" = config;
    };
  };
}
