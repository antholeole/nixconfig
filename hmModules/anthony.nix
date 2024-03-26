{ pkgs, inputs, config, sysConfig, lib, mkWaylandElectronPkg, mkNixGLPkg, ... }:
let
  theme = {
    package = pkgs.catppuccin-gtk;
    name = "Catppuccin-Frappe-Standard-Blue-Dark";

  };
in {
  fonts.fontconfig.enable = true;

  imports = [
    inputs.ags.homeManagerModules.default

    inputs.nix-index-database.hmModules.nix-index
    "${inputs.self}/mixins/mutable.nix"
  ];

  gtk = {
    enable = !sysConfig.headless;
    inherit theme;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "mauve";
        flavor = "mocha";
      };
    };

    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

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

  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
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
        trashy # allows us to move stuff to a trash dir
        bottom # top but nicer
        socat # sometimes socat is useful for quick hacks
        nixfmt # most projects are going to have a flake.nix. this is helpful
        watchexec # code agnostic file watcher. very helpful for dev setups
        parallel # xargs but I like it better
        tldr # i HATE manpages
        rclone # very useful for remote stuff
        spr # useful for github stacked PRs

        (symlinkJoin {
          name = "fx";
          paths =
            [ fx deno ]; # packaging in deno allows for reducers (ex: fx x.name)
        })

        neofetch # for funzies
        ttyper # funzies

        # LANGUAGE SPECIFIC
        # These are here because vscode unfortunately does not have the
        # best integration with the world.
        go
        d2
      ] ++ (if !sysConfig.headless then [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        fira-code-symbols
        dejavu_fonts
        libnotify
        glib # for notifications
        pwvucontrol

        mpc-cli # music
        brightnessctl
        pipes-rs # for funzies
        wl-clipboard # clipboard
        dbeaver
        pamixer

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
