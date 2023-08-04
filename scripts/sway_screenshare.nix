{
  overlay = self: super: {
    sss = super.writeShellApplication {
      name = "sss";
      text = ''
        #!/usr/bin/env bash
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

      export XDG_CURRENT_DESKTOP=sway # xdg-desktop-portal
      export XDG_SESSION_DESKTOP=sway # systemd
      export XDG_SESSION_TYPE=wayland # xdg/systemd

      systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
      '';
    };
  };
}
