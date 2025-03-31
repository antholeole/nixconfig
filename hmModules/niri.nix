{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.niri-flake.homeModules.niri
  ];

  config.programs.niri = let
    startupsh = pkgs.writeShellScriptBin "startup.sh" ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      ${builtins.concatStringsSep "\n" config.conf.wmStartupCommands}
    '';
  in {
    enable = !config.conf.headless;

    # TODO convert this to nix one day.
    config = builtins.readFile "${inputs.self}/confs/niri/config.kdl";

    package = pkgs.niri-stable.overrideAttrs (cfg: {
      buildInputs =
        cfg.buildInputs
        ++ [
          pkgs.niri-stable

          pkgs.makeWrapper
        ];

      postInstall = ''
        ${cfg.postInstall}

        wrapProgram $out/bin/niri-session \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          startupsh

          config.programs.alacritty.package
          config.programs.wpaperd.package
          config.programs.fuzzel.package
          config.programs.waybar.package
        ]}
      '';
    });
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
          nixGL ${config.programs.niri.package}/bin/niri-session | systemd-cat -t niri
        '';
      }}/bin/niri-wm
      Type=Application
    '';

    initNiri = pkgs.writeShellScriptBin "init-niri" ''
      sudo cp ${dotDesktop} /usr/share/wayland-sessions/niri.desktop
      sudo cp ${config.programs.niri.package}/share/xdg-desktop-portal/niri-portals.conf /usr/local/share/xdg-desktop-portal/niri-portals.conf
    '';
  in
    if (!config.conf.headless && !config.conf.nixos)
    then [
      initNiri
    ]
    else [];
}
