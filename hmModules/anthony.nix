{ pkgs, inputs, config, sysConfig, lib, mkWaylandElectronPkg, mkNixGLPkg, ...
}: {
  fonts.fontconfig.enable = true;

  imports = [ inputs.ags.homeManagerModules.default ];

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

    file.".ssh/id_ed25519.pub" = {
      enable = true;
      source = "${inputs.self}/assets/id_ed25519.pub";
    };

    file.".ssh/config" = {
      enable = true;
      source = "${inputs.self}/assets/config";
    };

    packages = with pkgs;
      [
        fd # a faster find
        httpie # a simpler curl
        unzip
        fx # jq but simpler
        neofetch # for funzies
        trashy # allows us to move stuff to a trash dir 
        bottom # top but nicer
        socat # sometimes socat is useful for quick hacks
        nixfmt # most projects are going to have a flake.nix. this is helpful
        watchexec # code agnostic file watcher. very helpful for dev setups
        parallel # xargs but doesn't take 1 million years

        # LANGUAGE SPECIFIC
        # These are here because vscode unfortunately does not have the
        # best integration with the world.
        go 
      ] ++ (if !sysConfig.headless then [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        fira-code-symbols
        dejavu_fonts
        dunst
        libnotify
        glib # for notifications
        pavucontrol
        mpc-cli # music
        brightnessctl
        pipes-rs # for funzies
        wl-clipboard # clipboard
        dbeaver
        pamixer
        joplin

        (mkWaylandElectronPkg {
          pkg = activitywatch;
          exeName = "aw-watcher-window";
        })

        # some useful formatters for one-off scripts
        nixfmt
        python311Packages.flake8
      ] else
        [ ]);
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
