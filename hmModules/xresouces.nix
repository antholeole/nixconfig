{
  lib,
  config,
  ...
}: {
  xresources =
    lib.mkIf (!config.conf.headless) {properties = {"Xft.dpi" = 210;};};
}
