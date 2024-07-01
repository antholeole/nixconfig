{ pkgs, lib, sysConfig, inputs, ... }: {
  services.kanshi = lib.mkIf (!sysConfig.headless) {
    enable = true;

    systemdTarget = "hyprland-session.target";

    profiles = let
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
        };
    in {
      latopOnly = mkKanshiConfig [ laptop ];
      dellUltrawide = mkKanshiConfig [ ultraWide laptop ];
      second = mkKanshiConfig [ laptop monitor ];
    };
  };
}
