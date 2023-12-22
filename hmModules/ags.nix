{ sysConfig, pkgs, inputs, config, lib, ... }: {
  programs.ags = {
    enable = !sysConfig.headless;
    configDir = "${inputs.self}/confs/ags";
  };

  home.file.".config/data/launcher.json" = {
    enable = !sysConfig.headless;

    text = with pkgs;
      builtins.toJSON ({
        "alacritty (daily)" =
          "${lib.getExe alacritty} -e ${zellij}/bin/zellij --layout daily";
        "alacritty (default)" =
          "${lib.getExe alacritty} -e ${zellij}/bin/zellij";
        "code" = "${config.programs.vscode.package}/bin/code";
        "pavucontrol" = "${lib.getExe pavucontrol}";
      } // sysConfig.wofiCmds);
  };

  systemd.user.services.ags.Service =
    let agsExe = pkgs.lib.getExe inputs.ags.packages."${pkgs.system}".default;
    in {
      Restart = "Always";
      
      # needs hyprland on path or it fails
      Environment="PATH=${pkgs.hyprland}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
      ExecStart = "${agsExe}";
    };
}

