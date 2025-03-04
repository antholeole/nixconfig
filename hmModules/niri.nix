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

  home.file.".config/other/niri.desktop" = let
    startupsh = pkgs.writeShellScriptBin "startup.sh" ''
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      ${builtins.concatStringsSep "\n" config.conf.wmStartupCommands}
    '';
  in {
    enable = !config.conf.headless;
    text = ''
      [Desktop Entry]
      Name=Niri
      Comment=Main WM
      Exec=${pkgs.writeShellApplication {
        name = "niri-wm";
        runtimeInputs = with pkgs; [
          config.programs.alacritty.package
          niri
          nixgl.auto.nixGLDefault
          config.programs.wpaperd.package
          fuzzel
          startupsh
        ];
        text = ''
          nixGL niri | systemd-cat -t niri
        '';
      }}/bin/niri-wm
      Type=Application
    '';
  };
}
