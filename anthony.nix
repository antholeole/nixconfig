{ config, lib, pkgs, inputs, ... }:
{
  nix.settings.trusted-users = [ "anthony" ];
  users.users.anthony = {
     hashedPassword = "$6$uaFo6AHeGdLRvmQj$HKH9T/SMrDL7779uDT50x6Ypfip0doG7lKcXNvBr03tAcTUHDvKTQ8kNSWP7Dj9E6TlNsln/uW0MC4WxGr3B10";
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     packages = [
       pkgs.firefox
       pkgs.vscodium
       pkgs.thunderbird
     ];
  };

  #home-manager.users = {
  #  anthony = {
  #    home = {
  #      username = "anthony";
  #      homeDirectory = "/home/anthony";
  #
  #      packages = with pkgs; [];
  #    };
#
#
 #     home.stateVersion = "20.03";
  #  }; 
  #};
}