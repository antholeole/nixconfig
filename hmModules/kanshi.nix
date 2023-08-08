{ pkgs, lib, sysConfig, ... }: {
  services.kanshi = lib.mkIf (!sysConfig.headless) {
    enable = true;

    profiles = {
        dellUltrawide = let 
          monitor = "DP-2";
          laptop = "eDP-1";
        in {
          outputs = [
            {
              criteria = laptop; # laptop
            }
            {
              criteria = monitor;
              mode = "2560x1440@59.951Hz";
              scale = 1.0;
            }
          ];

          exec = [
            "${pkgs.swaybg}/bin/swaybg -i ~/wall.png -c \"#1e2030\" -m center -o ${laptop}"
            "${pkgs.swaybg}/bin/swaybg -i ~/wall_tall.png -c \"#1e2030\" -m center -o ${monitor}"
          ];
        };
    };
  };
}