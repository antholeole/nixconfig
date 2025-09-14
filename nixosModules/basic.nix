{
  pkgs,
  config,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    busybox
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

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  users.users.anthony = {
    isNormalUser = true;
    description = "anthony";
    extraGroups = ["networkmanager" "wheel"];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
