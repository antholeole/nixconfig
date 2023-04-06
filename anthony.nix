{ config, lib, pkgs, inputs,  ... }:
{
  imports = [
    "${inputs.self}/modules/xfce/enable.nix"
    "${inputs.self}/modules/code/code.nix"
    "${inputs.self}/modules/starship.nix"
  ];

    fonts.fonts = with pkgs; [
      fira-code
      fira-code-symbols
    ];  

  nix.settings.trusted-users = [ "anthony" ];
  users.users.anthony = {
     hashedPassword = "$6$xuFopCWKzelX4Vss$ZHWmWZBQBZzZcXOFdQ7ADulpI2rhfDhKXNl6oYI9sj3Y8suKF.VG1Q/1lPb.NL/54inHR8pSbeIItzDQsz.bN/";
     isNormalUser = true;
     extraGroups = [ "wheel" ];
  };

  home-manager.users = {
    anthony = {
      fonts.fontconfig.enable = true;

      home = {
        username = "anthony";
        homeDirectory = "/home/anthony";
  
        packages = with pkgs; [
          firefox
          python3
        ];
      };

      programs = {
        bash = {
          enable = true;
          
          bashrcExtra = ''
            eval "$(starship init bash)"
          '';
        };

        direnv = {
          enableBashIntegration = true;
          enable = true; 
        };
      };
      
      home.stateVersion = "20.03";
    }; 
  };
}