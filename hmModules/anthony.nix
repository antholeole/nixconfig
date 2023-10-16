{ pkgs, inputs, config, sysConfig, lib, mkWaylandElectronPkg, ... }: {
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
  };

  gtk = lib.mkIf (!sysConfig.headless) {
    enable = true;
    theme = {
      name = "Catppuccin-Frappe-Standard-Flamingo-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "flamingo" ];
        size = "standard";
        tweaks = [ "rimless" ];
        variant = "macchiato";
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
        unzip
        dconf
        fx
        neofetch
        trashy
        entr
        bottom
        google-cloud-sdk
        nixfmt
      ] ++ (if !sysConfig.headless then [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        fira-code-symbols
        dejavu_fonts
        dunst
        libnotify
        glib # for notifications
        pavucontrol
        swaybg
        mpc-cli # music
        shutter-save # screenshotter (activated thru fluxbox keys)
        slock # screen locker
        brightnessctl
        pipes-rs # for funziesi
        wl-clipboard # clipboard
        dbeaver
        pamixer

        # some useful formatters for one-off scripts
        nixfmt
        python311Packages.flake8
      ] else [ ]);
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
