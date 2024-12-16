{
  lib,
  config,
  inputs,
  ...
}: {
  programs.wpaperd = {
    enable = !config.conf.headless;
    settings = let
      config = {
        path = "${inputs.self}/confs/bgs/bg.png";
      };
    in {
      "eDP-1" = config;
      "DP-3" = config;
      "HDMI-A-1" = config;
    };
  };
}
