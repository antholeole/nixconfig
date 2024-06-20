{ inputs, sysConfig, ... }: {
    home.file."backgrounds" = {
      enable = !sysConfig.headless;
      source = "${inputs.self}/confs/bgs";
    };

    programs.wpaperd = {
      enable = !sysConfig.headless;
      settings = {
        default = {
          sorting = "random";
          mode = "fit";
          duraton = "10s";
          path = "~/backgrounds";
        };
        
        any = {
          path = "~/backgrounds";
        };
      };
    };
}

