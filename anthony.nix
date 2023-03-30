{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    "${inputs.self}/modules/gnome.nix"
  ];

  nix.settings.trusted-users = [ "anthony" ];
  users.users.anthony = {
     hashedPassword = "$6$xuFopCWKzelX4Vss$ZHWmWZBQBZzZcXOFdQ7ADulpI2rhfDhKXNl6oYI9sj3Y8suKF.VG1Q/1lPb.NL/54inHR8pSbeIItzDQsz.bN/";
     isNormalUser = true;
     extraGroups = [ "wheel" ];
  };

  home-manager.users = {
    anthony = {
      home = {
        username = "anthony";
        homeDirectory = "/home/anthony";
  
        packages = with pkgs; [
          firefox
          vscodium
          thunderbird
        ];
      };

      programs = {
        git = {
          enable = true;
          userName  = "antholeole";
          userEmail = "antholeinik@gmail.com";
        };  

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