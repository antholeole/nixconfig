{ sysConfig, pkgs, inputs, config, lib, ... }: {
  programs.ags = {
    enable = !sysConfig.headless;
    configDir = "${inputs.self}/confs/ags";
    extraPackages = with pkgs; [ fzf hyprland ];
  };

  home.file.".config/data/launcher.json" = {
    enable = !sysConfig.headless;

    text = with pkgs; let 
      broPleaseItsWaylandTrustMe = pgm: "DESKTOP_SESSION=hyprland XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 XDG_BACKEND=wayland ${pgm}";

      entries = {
        "alacritty (daily)" = "${lib.getExe alacritty} -e ${zellij}/bin/zellij --layout daily";
        "alacritty (default)" =
          "${lib.getExe alacritty} -e ${zellij}/bin/zellij --layout default";
        "pavucontrol" = "${lib.getExe pavucontrol}";

        "code" = broPleaseItsWaylandTrustMe "${config.programs.vscode.package}/bin/code";
        "chrome" = broPleaseItsWaylandTrustMe "/bin/google-chrome";
      };
    in
      builtins.toJSON entries;
  };

  systemd.user.services.ags.Service =
    let agsExe = pkgs.lib.getExe inputs.ags.packages."${pkgs.system}".default;
    in {
      Restart = "always";

      # needs hyprland on path or it fails
      Environment =
        "PATH=${pkgs.fzf}/bin:${pkgs.hyprland}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
      ExecStart = "${agsExe}";
      ExecStartPre = "-/bin/pkill ags";
    };
}

