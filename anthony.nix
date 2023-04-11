{ config, lib, pkgs, inputs,  ... }:
{
  imports = [
    "${inputs.self}/modules/xfce/enable.nix"
  ];

    fonts.fonts = with pkgs; [
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode"
          "JetBrainsMono" 
        ]; 
      })
      fira-code-symbols
      jetbrains-mono      
    ];  


  home-manager.users = {
    anthony = {
      fonts.fontconfig.enable = true;

      home = {
        username = "anthony";
        homeDirectory = "/home/anthony";
  
        packages = with pkgs; [
          firefox
          polypomo
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

        
        # git
        # rofi?
        # polybar
        # wlsunset
        # https://discourse.nixos.org/t/setting-caps-lock-as-ctrl-not-working/11952/3 
        # xshkd?

        direnv = {
          enableBashIntegration = true;
          enable = true; 
        };
      };
      
      home.stateVersion = "20.03";
    }; 
  };
}