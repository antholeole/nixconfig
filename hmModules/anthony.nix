{ pkgs, inputs, config, sysConfig, lib, ... }: {   
  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services = lib.mkIf (!sysConfig.headless) {
    playerctld.enable = true;
    blueman-applet.enable = sysConfig.bluetooth;
    gnome-keyring.enable = true;
    unclutter.enable = true;
  };

  gtk = lib.mkIf (!sysConfig.headless) {
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
    homeDirectory = "${sysConfig.homeDirPath}${sysConfig.name}";
    
    # file."wall.png" = { TODO figure out why this isnt working
    #   enable = !sysConfig.headless;
    #   source = "${inputs.self}/images/${if sysConfig.laptop then "bg" else "bg_tall"}.png";
    # };

    packages = with pkgs;
      [
        fd # find!
        tree
        httpie
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
        sss
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
        dbeaver
      ] else [])
      ++ (if sysConfig.nixgl != null then [ nixgl.auto."nixGL${sysConfig.nixgl}" ] else []) 
      ++ (if pkgs.system == "x86_64-linux" && !sysConfig.headless then [ insomnia ] else [ postman ]);
  };

  programs = lib.mkIf (!sysConfig.headless) {
    keychain = {
      enable = true;
      enableXsessionIntegration = true;
    };

    home-manager.enable = true;
    ncmpcpp.enable = true;
  };

  home.stateVersion = "23.05";
}
