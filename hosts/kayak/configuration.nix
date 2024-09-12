# don't set  default for because it is potentially dangerous.
# if we accidently boot without basic firmware support that is bad news
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = ["${inputs.self}/hardware-configuration.nix"];

  nix.settings.trusted-users = ["anthony"];
  users.users.anthony = {
    hashedPassword = "$6$xuFopCWKzelX4Vss$ZHWmWZBQBZzZcXOFdQ7ADulpI2rhfDhKXNl6oYI9sj3Y8suKF.VG1Q/1lPb.NL/54inHR8pSbeIItzDQsz.bN/";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "audio" # pulseaudio
      "video" # add to group that can control brightness
      "networkmanager" # self explanatory
    ];

    shell = pkgs.fish;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "kayak";

  networking.networkmanager.enable = true;

  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";
  users.mutableUsers = false;

  sound.enable = true;
  nix.settings.auto-optimise-store = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.opengl.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs = {
    nix-ld.enable = true;
    fish.enable = true;
  };

  services.xserver = {
    enable = true;

    layout = "us";

    xkbOptions = "ctl:swap_lwin_lctl";

    desktopManager.lxqt.enable = true;
    windowManager.fluxbox.enable = true;

    displayManager = {
      defaultSession = "lxqt+fluxbox";
      lightdm.enable = true;
    };
  };

  # we should install slock through home-manager.
  security.wrappers.slock = {
    setuid = true;
    owner = "root";
    group = "root";

    source = "${pkgs.slock.out}/bin/slock";
  };

  system.stateVersion = "23.05";
}
