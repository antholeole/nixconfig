# don't set  default for asahi because it is potentially dangerous. 
# if we accidently boot without basic firmware support that is bad news
{ config, pkgs, lib, inputs, asahi, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [ 
      "${inputs.self}/anthony.nix"
      "${inputs.self}/hardware-configuration.nix"
    ] ++ lib.optional (asahi) "${inputs.self}/mixins/asahi.nix";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "kayak";
  
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkbOptions in tty.
  };

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

