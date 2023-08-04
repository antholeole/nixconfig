{ pkgs, sysConfig, lib, ... }:
let
  colors = import ../theme.nix;
  seperator = {
    format = "|";
    interval = "once";
  };
in
with sysConfig; {
  programs.waybar = lib.mkIf (!sysConfig.headless) {
      enable = true;
      systemd.enable = true;
      
      settings = {
        bar = {
          layer = "top";
          position = "top";
          height = 30;
          
          modules-left = [ "brightness" "alsa" "custom/polydoro" ];
          modules-center = [ "mpd" ];
          modules-right = (if laptop != null then [ "battery" "custom/sep" ] else [ ]) ++ [ "clock" ];
            output = [
              "eDP-1"
              "DP-2"
            ];

          "custom/sep" = seperator;

          "clock" = {
            type = "internal/date";
            format = "{:%A, %B %d %I:%M:%S %p}";
            timezone = "US/Pacific";
            interval = 1;
          };

          "battery" = lib.mkIf (laptop != null) {
              full-at = "98";
              low-at = "10";

              format = "{icon}   {capacity}%";
              format-icons = ["" "" "" "" ""];
              format-charging = "󰂄 {capacity}%";
              format-full = " ";
              interval = 30;

              states = {
                "warning" = 25;
                "critical" = 10;
              };

              tooltip = false;
          }; 
          

          "custom/polydoro" =
            let
              polydoroPath = "${pkgs.polydoro}/bin/polydoro";
            in
            {
              exec = "${polydoroPath} run -f";
              exec-on-event = false;

              on-click = "${polydoroPath} toggle";
              on-click-right = "${polydoroPath} skip";
          };
        };
      };
    };

    #config = lib.mkIf false {
    #  "bar/bar" = {
    #    width = "100%";
    #    height = "${toString (fontSizes.defaultFontSize * 2)}pt";
    #    offset-x = "0";
    #    offset-y = "0";

    #    background = "${colors.mantle}";
    #    foreground = "${colors.text}";
    #    line-size = "3pt";
    #    padding-left = "1";
    #    padding-right = "0";


    #    font-0 = "FiraCode Nerd Font:weight=200:pixelsize=${toString (fontSizes.defaultFontSize * 2)}";
    #  };

    #  "module/sep1" = seperator;
    #  "module/sep2" = seperator;

    #  "module/brightness" = lib.mkIf (sysConfig.laptop != null) {
    #    type = "internal/backlight";
    #    card = sysConfig.laptop.brightnessDir;

    #    enable-scroll = "true";

    #    format = "󰃠 <bar>";

    #    bar-width = "10";
    #    bar-indicator = "|";
    #    bar-fill = "─";
    #    bar-empty = "─";
    #  };

    #  "module/alsa" = lib.mkIf sysConfig.alsaSupport {
    #    type = "internal/alsa";

    #    format-volume = "󱄠 <bar-volume> ";
    #    format-muted = "󰝟 <bar-volume> ";

    #    bar-volume-width = "10";
    #    bar-volume-indicator = "|";
    #    bar-volume-fill = "─";
    #    bar-volume-empty = "─";
    #  };
    #  

   #};
  #};
}
