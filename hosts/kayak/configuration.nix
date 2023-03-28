# don't set  default for asahi because it is potentially dangerous. 
# if we accidently boot without basic firmware support that is bad news
{ config, pkgs, lib, inputs, asahi, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [ 
      ../../hardware-configuration.nix
      "${inputs.self}/anthony.nix"
    ] ++ lib.optional (asahi) "${inputs.self}/mixins/asahi.nix";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  age.identityPaths = [
    "/home/anthony/.ssh/id_rsa"
  ];

  networking.hostName = "kayak";
  
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.dpi = 227;

  users.mutableUsers = false;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  system.stateVersion = "23.05";
}

