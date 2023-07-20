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
    username = sysConfig.name;
    homeDirectory = "${if sysConfig.homeDirPath == null then "/home/" else sysConfig.homeDirPath}${sysConfig.name}";

    packages = with pkgs;
      [
        fd # find!
        tree
        python3
        unzip
        dconf
        jq
        neofetch
        # fonts
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        fira-code-symbols
        dejavu_fonts
      ] ++ (if !sysConfig.headless then [
        dunst
        gapp
        libnotify
        nt # quick shot note taking system
        glib # for notifications
        feh # for background
        pavucontrol
        mpc-cli # music
        chromium # browser
        polydoro # polybar pomodoro timer
        shutter-save # screenshotter (activated thru fluxbox keys)
        slock # screen locker
        xorg.xbacklight # brightness
        xclip # clipboard
      ] else [])
      ++ (if sysConfig.nixgl != null then [ nixgl.auto."nixGL${sysConfig.nixgl}" ] else []) 
      ++ (if pkgs.system == "x86_64-linux" && !sysConfig.headless then [ insomnia ] else [ postman ]);
  };

  programs = {
    keychain = {
      enable = true;
      enableXsessionIntegration = true;
    };

    home-manager.enable = true;
    ncmpcpp.enable = true;
  };

  home.stateVersion = "23.05";
}
