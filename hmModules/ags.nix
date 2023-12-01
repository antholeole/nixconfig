{ sysConfig, pkgs, inputs, config, lib, ... }: {
    programs.ags = {
        enable = !sysConfig.headless;
        configDir = "${inputs.self}/confs/ags";
    };


    home.file.".config/data/launcher.json" = {
      enable = !sysConfig.headless;

      text = with pkgs; builtins.toJSON ({
        "alacritty (default)" = "${lib.getExe alacritty}";
        "code" = "${config.programs.vscode.package}/bin/code";
        "pavucontrol" = "${lib.getExe pavucontrol}";
      } // sysConfig.wofiCmds);
    };
}

