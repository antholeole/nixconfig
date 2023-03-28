{ config, lib, pkgs, inputs, ... }:
{
  age.secrets.antspass.file = "${inputs.self}/secrets/antspass.page";

  nix.settings.trusted-users = [ "anthony" ];
  users.users.anthony = {
     hashedPassword = "$6$uaFo6AHeGdLRvmQj$HKH9T/SMrDL7779uDT50x6Ypfip0doG7lKcXNvBr03tAcTUHDvKTQ8kNSWP7Dj9E6TlNsln/uW0MC4WxGr3B10";
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     packages = [
       pkgs.firefox
       pkgs.vscodium
       pkgs.thunderbird
       inputs.agenix.packages."${pkgs.system}".default
     ];
  };

  home-manager.users = {
    anthony = {
      home = {
        username = "anthony";
        homeDirectory = "/home/anthony";

        packages = with pkgs; [
          ripgrep
        ];
      };

      programs = {
        starship = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            username = {
              format = "user: [$user]($style) ";
              show_always = true;
            };
            shlvl = {
              disabled = false;
              format = "$shlvl ▼ ";
              threshold = 4;
            };
          };
        };
      };

      home.stateVersion = "20.03";
    }; 
  };
}