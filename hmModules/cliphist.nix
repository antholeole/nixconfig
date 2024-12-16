{
  pkgs,
  lib,
  config,
  ...
}: {
  services.cliphist.enable = !config.conf.headless;
}
