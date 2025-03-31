{
  pkgs,
  inputs,
  config,
  mkWaylandElectronPkg,
  lib,
  ...
}: {
  fonts.fontconfig.enable = true;

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

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
      source = "${inputs.self}/assets/id_ed25519.pub";
    };

    file.".ssh/config" = {
      enable = true;
      source = "${inputs.self}/assets/config";
    };

    packages = with pkgs; let
      deltaWrapped = pkgs.writeShellScriptBin "d" ''
        DELTA_PAGER="${pkgs.less}/bin/less -RXF" ${delta}/bin/delta $@
      '';
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
        tldr # i HATE manpages
        rclone # very useful for remote stuff
        direnv # vsc ext checks path for this
        neofetch # for funzies
        ncdu # see where our big folders are
        nixgl.auto.nixGLDefault # unboxing nix sad
        gawk
        gron # greppable json
        aspell
        aspellDicts.en
        deltaWrapped # diffing
      ]
      ++ (
        if !config.conf.headless
        then [
          (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
          fira-code-symbols
          dejavu_fonts
          libnotify
          glib # for notifications
          pwvucontrol
          (mkWaylandElectronPkg anytype "anytype")
          grimblast
          obs-cli
          taskwarrior-tui # doesn't really require headless but only use it on my desktop
          brightnessctl
          wl-clipboard # clipboard
          mpc-cli
        ]
        else []
      );
  };

  programs = lib.mkIf (!config.conf.headless) {
    keychain = {
      enable = true;
      enableXsessionIntegration = true;
    };

    home-manager.enable = true;
    ncmpcpp.enable = true;
  };

  home.stateVersion = "23.05";
}
