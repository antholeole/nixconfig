{ sysConfig, pkgs, inputs, ... }: {
    programs.ags = {
        enable = !sysConfig.headless;
        configDir = "${inputs.self}/confs/ags";
    };
}

