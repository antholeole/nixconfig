{
  lib,
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  gtk = {
    enable = !config.conf.headless;
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
  };

  home.packages = with pkgs;
    lib.mkIf (!config.conf.headless) [
      nerd-fonts.fira-code
      libnotify
      glib # for notifications
      pwvucontrol
      obs-cli
      taskwarrior-tui # doesn't really require headless but only use it on my desktop
      brightnessctl
      wl-clipboard # clipboard
      mpc-cli
      swappy # image editing
      nix-output-monitor

      # gui stuff
      nautilus # files
      mpv # vidoes
      networkmanagerapplet # network
    ];
}
