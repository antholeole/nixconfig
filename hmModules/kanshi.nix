{ pkgs, lib, sysConfig, ... }: {
  services.kanshi = lib.mkIf (!sysConfig.headless) {
    enable = true;

    profiles =
      let
        mkBgStatement = criteria: if criteria.tall then 
            "${pkgs.swaybg}/bin/swaybg -i ~/wall_tall.png -c \"#1e2030\" -m center -o ${criteria.kanshi.criteria}"
         else 
            "${pkgs.swaybg}/bin/swaybg -i ~/wall.png -c \"#1e2030\" -m center -o ${criteria.kanshi.criteria}";
        ultraWide = {
          tall = true;
          kanshi = {
            criteria = "DP-2";
            mode = "2560x1440@59.951Hz";
            scale = 1.0;
          };
        };
        laptop = {
          tall = false;
          kanshi = {
            criteria = "eDP-1";
          };
        };
        monitor = {
          tall = true;
          kanshi = {
            criteria = "HDMI-A-1";
          };
        };
        mkKanshiConfig = displays: with builtins; {
          outputs = map (display: display.kanshi) displays;
          exec = map mkBgStatement displays; 
        };
      in
      {
        dellUltrawide = mkKanshiConfig [
          ultraWide
          laptop
        ];
        second = mkKanshiConfig [
          laptop
          monitor
        ];
      };
  };
}