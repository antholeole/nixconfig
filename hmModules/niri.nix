{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  enableNiri = config.conf.wm && !config.conf.headless;
in {
  imports = [
    inputs.niri-flake.homeModules.niri
  ];

  config.programs.niri = let
    startupsh = pkgs.writeShellScriptBin "startup.sh" ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      ${builtins.concatStringsSep "\n" config.conf.wmStartupCommands}
    '';
  in {
    enable = enableNiri;

    # TODO convert this to nix one day.
    config = let
      defaultConfig = builtins.readFile "${inputs.self}/confs/niri/config.kdl";
    in
      # seems to build niri without lib.mkIf here. This is likely because it
      # uses niri to check the file is valid in check phase.
      lib.mkIf enableNiri ''
        ${defaultConfig}
      '';

    package =
      (pkgs.symlinkJoin {
        name = "niri-wrapped";
        paths = [
          startupsh
          config.programs.alacritty.package
          config.programs.waybar.package

          pkgs.fuzzel-omnibar
          pkgs.niri
          pkgs.wl-clipboard
        ];
      })
      // {
        # niri flake reads these directly, just pass them through.
        inherit (pkgs.niri) cargoBuildNoDefaultFeatures cargoBuildFeatures;
      };
  };

  config.home.packages = let
    # TODO: we should do this in postinstall so we can copy the .desktop
    # created in the drv instead of making our own. But this works for now -
    # calling nixgl and using systemd cat is not so easy.
    dotDesktop = pkgs.writeText "niri.desktop" ''
      [Desktop Entry]
      Name=Niri
      Comment=Main WM
      Exec=${pkgs.writeShellApplication {
        name = "niri-wm";
        runtimeInputs = with pkgs; [
          nixgl.auto.nixGLDefault
        ];
        text = ''
          GBM_BACKENDS_PATH="${pkgs.mesa}/lib/gbm" nixGL ${config.programs.niri.package}/bin/niri-session | systemd-cat -t niri
        '';
      }}/bin/niri-wm
      Type=Application
    '';

    initNiri = pkgs.writeShellScriptBin "init-niri" ''
      sudo cp ${dotDesktop} /usr/share/wayland-sessions/niri.desktop
      sudo cp ${config.programs.niri.package}/share/xdg-desktop-portal/niri-portals.conf /usr/local/share/xdg-desktop-portal/niri-portals.conf
      sudo cp ${config.programs.niri.package}/share/systemd/user/* /etc/systemd/user/
    '';
  in
    if
      (enableNiri
        &&
        # already in the right place on nixos
        !config.conf.nixos)
    then [
      initNiri
    ]
    else [];
}
