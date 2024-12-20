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
  programs.ags = {
    inherit configDir;
    enable = !config.conf.headless;
    extraPackages = with pkgs; [fzf hyprland];
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
}
