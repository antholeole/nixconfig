{ config, pkgs, inputs,  ... }:
{
    fonts.fonts = with pkgs; [
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode"
          "JetBrainsMono" 
        ]; 
      })
      fira-code-symbols
    ];    

  home-manager.users.anthony = { lib, ... }: {
      fonts.fontconfig.enable = true;

      xsession.enable = true;

      gtk = {
          enable = true;
          theme = {
            name = "Catppuccin-Frappe-Standard-Flamingo-Dark";
            package = pkgs.catppuccin-gtk.override {
              accents = [ "flamingo" ];
              size = "standard";
              tweaks = [ "rimless" ];
              variant = "frappe";
            };
          };
      };

      home = {
        username = "anthony";
        homeDirectory = "/home/anthony";
  
        packages = with pkgs; [
          chromium
          polypomo
          shutter
          python3
          unzip
          gtk-engine-murrine
          dconf
          feh # for background
        ];
      };

      programs = {
        keychain = {
          enable = true;
          enableXsessionIntegration = true;
        };

        bash = {
          enable = true;

          bashrcExtra = ''
            eval "$(starship init bash)";
            function cdc { mkdir -p $1 && cd $1; };
          '';
        };

        # rofi?
        # wlsunset
        # https://discourse.nixos.org/t/setting-caps-lock-as-ctrl-not-working/11952/3 

        direnv = {
          enableBashIntegration = true;
          enable = true; 
        };
      };
      
      home.stateVersion = "20.03";
    }; 
}
