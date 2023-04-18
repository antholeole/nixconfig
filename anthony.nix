{ config, pkgs, inputs,  ... }:
{
  imports = [
    "${inputs.self}/modules/xsession.nix"

  ];

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
        activation = {
          polybar = lib.hm.dag.entryAnywhere "systemctl --user restart polybar";
        };

        username = "anthony";
        homeDirectory = "/home/anthony";
  
        packages = with pkgs; [
          firefox
          polypomo
          python3
          openbox
          gtk-engine-murrine
          dconf
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
}
