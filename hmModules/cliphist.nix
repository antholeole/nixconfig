{
  pkgs,
  lib,
  sysConfig,
  ...
}: {
  services.cliphist.enable = !sysConfig.headless;
}
