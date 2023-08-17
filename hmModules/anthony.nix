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
    
    file."wall.png" = {
      enable = !sysConfig.headless;
      source = "${inputs.self}/images/bg.png";
    };

    file."wall_tall.png" = {
      enable = !sysConfig.headless;
      source = "${inputs.self}/images/bg_tall.png";
    };

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
        trashy
      ] ++ (if !sysConfig.headless then [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        fira-code-symbols
        dejavu_fonts
        dunst
        gapp
        libnotify
        sss
        nt # quick shot note taking system
        glib # for notifications
        pavucontrol
        swaybg
        mpc-cli # music
        chromium # browser
        polydoro # polybar pomodoro timer
        shutter-save # screenshotter (activated thru fluxbox keys)
        slock # screen locker
        xorg.xbacklight # brightness
        wl-clipboard # clipboard
        dbeaver
        mosh # technically not headless only, but mostly we will use mosh to ssh
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
