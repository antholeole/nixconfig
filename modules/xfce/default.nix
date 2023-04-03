{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.dpi = 227;
}