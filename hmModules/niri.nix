{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.file.".config/niri/config.kdl" = {
    enable = !config.conf.headless;
    source = "${inputs.self}/confs/niri/config.kdl";
  };

  home.packages = let
    startupsh = pkgs.writeShellScriptBin "startup.sh" ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      ${builtins.concatStringsSep "\n" config.conf.wmStartupCommands}
    '';

    dotDesktop = pkgs.writeText "niri.desktop" ''
      [Desktop Entry]
      Name=Niri
      Comment=Main WM
      Exec=${pkgs.writeShellApplication {
        name = "niri-wm";
        runtimeInputs = with pkgs; [
          niri
          nixgl.auto.nixGLDefault

          startupsh

          config.programs.alacritty.package
          config.programs.wpaperd.package
          config.programs.fuzzel.package
          config.programs.waybar.package
        ];
        text = ''
          nixGL niri | systemd-cat -t niri
        '';
      }}/bin/niri-wm
      Type=Application
    '';

    initNiri =
      pkgs.writeShellScriptBin "init-niri" ''
        sudo cp ${dotDesktop} /usr/share/wayland-sessions/niri.desktop
        sudo cp ${pkgs.niri}/share/xdg-desktop-portal/niri-portals.conf /usr/local/share/xdg-desktop-portal/niri-portals.conf
      '';
  in if (config.conf.headless) then [] else [
    initNiri
  ];
}
