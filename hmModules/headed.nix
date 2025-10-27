{
  lib,
  config,
  pkgs,
  ...
}: let
  mkIfHeaded = lib.mkIf (!config.conf.headless && !config.conf.darwin);
in {
  fonts.fontconfig.enable = mkIfHeaded true;

  gtk = mkIfHeaded {
    enable = !config.conf.headless;
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  dconf.settings = mkIfHeaded {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
  };


  home.packages = with pkgs;
    mkIfHeaded [
      nerd-fonts.fira-code
      nerd-fonts.monaspace
      libnotify
      glib # for notifications
      pwvucontrol
      obs-cli
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
