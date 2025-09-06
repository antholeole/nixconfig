{
  pkgs,
  lib,
  ...
}: {
  xdg = {
    portal = {
      enable = lib.mkForce false;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
