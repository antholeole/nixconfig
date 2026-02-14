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

  home.packages = with pkgs;
    mkIfHeaded [
      nerd-fonts.fira-code
      libnotify
      glib # for notifications
      pwvucontrol
      obs-cli
      brightnessctl
      wl-clipboard # clipboard
      swappy # image editing
      nix-output-monitor

      # gui stuff
      nautilus # files
      mpv # vidoes
      networkmanagerapplet # network
    ];
}
