{ pkgs, lib, sysConfig, inputs, ... }: {
  services.kanshi = lib.mkIf (!sysConfig.headless) {
    enable = true;

    systemdTarget = "hyprland-session.target";

    profiles = let
      mkBgStatement = criteria:
        if criteria.tall then
          ''
            ${pkgs.swaybg}/bin/swaybg -i ~/wall_tall.png -c "#24273a" -m center -o ${criteria.kanshi.criteria}''
        else
          ''
            ${pkgs.swaybg}/bin/swaybg -i ~/wall.png -c "#24273a" -m center -o ${criteria.kanshi.criteria}'';
      ultraWide = {
        tall = false;
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
          scale = 2.4;
        };
      };
      monitor = {
        tall = true;
        kanshi = { criteria = "HDMI-A-1"; };
      };
      mkKanshiConfig = displays:
        with builtins; {
          outputs = map (display: display.kanshi) displays;
          exec = (map mkBgStatement displays) ++ [
            # I cannot get this to work
            "/usr/bin/pkill ags"
          ];
        };
    in {
      latopOnly = mkKanshiConfig [ laptop ];
      dellUltrawide = mkKanshiConfig [ ultraWide laptop ];
      second = mkKanshiConfig [ laptop monitor ];
    };
  };
}
