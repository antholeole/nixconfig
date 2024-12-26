{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  configDir = "${(import "${inputs.self}/confs/ags") {
    inherit pkgs;
    palette = config.colorScheme.palette;
  }}/lib";
in {
  config = {
    programs.ags = {
      inherit configDir;
      extraPackages = [];
      enable = !config.conf.headless;
    };

    home.file = {
      ".config/data/launcher.json" = {
        enable = !config.conf.headless;

        text = with pkgs; let
          broPleaseItsWaylandTrustMe = pgm: "DESKTOP_SESSION=hyprland XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 XDG_BACKEND=wayland ${pgm}";

          # TODO: this probably shouldn't be in this file its hard to find
          entries = {
            "alacritty" = "${config.programs.alacritty.package}/bin/alacritty -e ${pkgs.zellij}/bin/zellij";
            "code" =
              broPleaseItsWaylandTrustMe
              "${config.programs.vscode.package}/bin/code  --enable-features=UseOzonePlatform --ozone-platform=wayland";
            "chrome" =
              broPleaseItsWaylandTrustMe
              "/bin/google-chrome  --enable-features=UseOzonePlatform --ozone-platform=wayland";
            "qute" = "${config.programs.qutebrowser.package}/bin/qutebrowser";
          };
        in
          builtins.toJSON entries;
      };
    };
  };

  options.packages.ags-wrapped = lib.mkOption {
    type = lib.types.package;
    default = pkgs.symlinkJoin {
      name = "ags-wrapped";
      paths = [
        config.programs.fzf.package
        config.programs.ags.package
        config.wayland.windowManager.hyprland.package

        pkgs.upower
        pkgs.bashInteractiveFHS
        pkgs.pulseaudio
        pkgs.toybox
        pkgs.brightnessctl
      ];

      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/ags --set PATH $out/bin
      '';
    };
  };
}
