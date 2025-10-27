{
  pkgs,
  config,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.nix-ld.enable = true;
  services.envfs.enable = true; 

  environment.systemPackages = with pkgs; [
    busybox
    bluez
    bluetui
  ];

  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback.out
    ];

    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
    '';

    kernelModules = ["v4l2loopback" "88x2bu"];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        AutoEnable = true;
      };
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  networking.networkmanager = {
    enable = true;

    # openWRT hates random mac addresses
    wifi = {
      scanRandMacAddress = false;
      macAddress = "permanent";
      powersave = false;
    };
  };

  users.users.folu = {
    isNormalUser = true;
    description = "folu";
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "Init.123";
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
