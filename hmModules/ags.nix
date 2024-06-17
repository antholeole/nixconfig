{ sysConfig, pkgs, inputs, config, lib, ... }: {
  programs.ags = {
    enable = !sysConfig.headless;
    configDir = "${inputs.self}/confs/ags";
    extraPackages = with pkgs; [ fzf hyprland ];
  };

  home.file.".config/data/launcher.json" = {
    enable = !sysConfig.headless;

    text = with pkgs;
      let
        broPleaseItsWaylandTrustMe = pgm:
          "DESKTOP_SESSION=hyprland XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 XDG_BACKEND=wayland ${pgm}";

        entries = {
          "alacritty" =
            "${config.programs.alacritty.package}/bin/alacritty -e ${pkgs.zellij}/bin/zellij";
          "pavucontrol" = "${lib.getExe pwvucontrol}";
          "code" = broPleaseItsWaylandTrustMe
            "${config.programs.vscode.package}/bin/code  --enable-features=UseOzonePlatform --ozone-platform=wayland";
          "chrome" = broPleaseItsWaylandTrustMe
            "/bin/google-chrome  --enable-features=UseOzonePlatform --ozone-platform=wayland";
        };
      in builtins.toJSON entries;
  };

  systemd.user.services.ags = {
    Service = {
      Restart = "always";
      RestartSec = 2;

      # needs hyprland on path or it fails
      Environment =
        "PATH=${pkgs.fzf}/bin:${pkgs.hyprland}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
      ExecStart = "${config.programs.ags.package}/bin/ags";
      ExecStartPre = "/bin/pkill ags";
    };
  };
}

