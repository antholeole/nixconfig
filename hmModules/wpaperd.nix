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
        path = "/home/folu/Pictures/Wallwapers";
      };
    in {
      "default" = config;
    };
  };

  home.file."Pictures/Wallwapers" = {
    source = ../confs/bgs;
    recursive = true;
  };
}
