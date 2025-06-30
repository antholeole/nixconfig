{
  pkgs,
  self,
  config,
  lib,
  ...
}: {
  fonts.fontconfig.enable = true;

  gtk = {
    enable = !config.conf.headless;
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services = lib.mkIf (!config.conf.headless) {
    playerctld.enable = true;
    gnome-keyring.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
  };

  home = {
    username = config.conf.name;
    homeDirectory = "${config.conf.homeDirPath}${config.conf.name}";

    file.".ssh/id_ed25519.pub" = {
      enable = true;
      source = "${self}/assets/id_ed25519.pub";
    };

    file.".ssh/config" = {
      enable = true;
      source = "${self}/assets/config";
    };

    packages = with pkgs; let
      deltaWrapped = pkgs.writeShellScriptBin "d" ''
        DELTA_PAGER="${pkgs.less}/bin/less -RXF" ${delta}/bin/delta $@
      '';

      notHeadlessPkgs =
        if !config.conf.headless
        then [
          nerd-fonts.fira-code
          libnotify
          glib # for notifications
          pwvucontrol
          obs-cli
          taskwarrior-tui # doesn't really require headless but only use it on my desktop
          brightnessctl
          wl-clipboard # clipboard
          mpc-cli
          swappy # image editing
          nautilus # files
          totem # vidoes
          nix-output-monitor
        ]
        else [];

      x86Pkgs =
        if (pkgs.system == "x86_64-linux" && !config.conf.headless)
        then []
        else [];

      featureLocked = with pkgs; let
        featurePackages = {
          "video-editing" = [(config.lib.nixGL.wrap blender)];
          "gaming" = [
            (config.lib.nixGL.wrap xwayland-satellite)
          ];
        };
      in
        lib.flatten (builtins.map (feature: featurePackages."${feature}" or []) config.conf.features);
    in
      [
        fd # a faster find
        httpie # a simpler curl
        unzip
        jq
        yq
        repgrep # find replace
        bottom # top but nicer
        watchexec # code agnostic file watcher. very helpful for dev setups
        parallel # xargs but I like it better
        tldr 
        rclone # very useful for remote stuff
        direnv # vsc ext checks path for this
        neofetch # for funzies
        nixgl.auto.nixGLDefault # unboxing nix sad
        gawk
        gron # greppable json
        aspell
        aspellDicts.en
        deltaWrapped # diffing
      ]
      ++ notHeadlessPkgs
      ++ x86Pkgs
      ++ featureLocked;
  };

  programs = lib.mkIf (!config.conf.headless) {
    keychain = {
      enable = true;
      enableXsessionIntegration = true;
    };
  };

  home.stateVersion = "23.05";
}
