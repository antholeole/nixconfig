{ lib, sysConfig, ... }: {
  xresources =
    lib.mkIf (!sysConfig.headless) { properties = { "Xft.dpi" = 210; }; };
}
