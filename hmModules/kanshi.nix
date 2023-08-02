{ pkgs, lib, sysConfig, ... }: {
  services.kanshi = lib.mkIf (!sysConfig.headless) {
    enable = true;

    profiles = {
        dellUltrawide = {
          outputs = [
            {
              criteria = "eDP-1"; # laptop
            }
            {
              criteria = "DP-2";
              mode = "2560x1440@59.951Hz";
              scale = 1.0;
            }
          ];
        };
    };
  };
}