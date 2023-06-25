{ pkgs, inputs, config, sysConfig, ... }: {   
  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services = {
    playerctld.enable = true;
    blueman-applet.enable = sysConfig.bluetooth;
    gnome-keyring.enable = true;
    unclutter.enable = true;
  };

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

    packages = with pkgs;
      [
        pavucontrol
        mpc-cli # music
        chromium # browser
        polydoro # polybar pomodoro timer
        shutter-save # screenshotter (activated thru fluxbox keys)
        slock # screen locker
        xorg.xbacklight # brightness
        xclip # clipboard
        fd # find!
        tree
        gapp
        python3
        unzip
        dconf
        dunst
        libnotify
        glib # for notifications
        feh # for background
        fluxbox
        neofetch
        # fonts
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        fira-code-symbols
        dejavu_fonts
      ]
      ++ (if sysConfig.nixgl != null then [ nixgl.auto."nixGL${sysConfig.nixgl}" ] else []) 
      ++ (if pkgs.system == "x86_64-linux"then [ insomnia ] else [ postman ]);
  };

  programs = {
    keychain = {
      enable = true;
      enableXsessionIntegration = true;
    };

    direnv = {
      enableBashIntegration = true;
      enable = true;
    };

    home-manager.enable = true;
    ncmpcpp.enable = true;
  };

  home.stateVersion = "23.05";
}
