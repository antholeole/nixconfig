{ pkgs, sysConfig, lib, ... }:
let
  colors = import ../theme.nix;
  seperator = {
    type = "custom/text";
    content = "|";
    content-foreground = colors.subtext0;
  };
in
with sysConfig; {
  services.polybar = lib.mkIf (!sysConfig.headless) {
    enable = true;
    script = "polybar bar &";

    package = pkgs.polybar.override {
      mpdSupport = true;
      alsaSupport = true;
    };

    config = {
      "bar/bar" = {
        width = "100%";
        height = "${toString (fontSize * 2)}pt";
        offset-x = "0";
        offset-y = "0";

        background = "${colors.mantle}";
        foreground = "${colors.text}";
        line-size = "3pt";
        padding-left = "1";
        padding-right = "0";

        modules-left = [ "brightness" "alsa" "polydoro" ];
        modules-center = [ "mpd" ];
        modules-right = (if laptop != null then [ "battery" "sep1" ] else [ ]) ++ [ "date" ];

        font-0 = "FiraCode Nerd Font:weight=200:pixelsize=${toString fontSize}";
      };

      "module/sep1" = seperator;
      "module/sep2" = seperator;

      "module/brightness" = lib.mkIf (sysConfig.laptop != null) {
        type = "internal/backlight";
        card = sysConfig.laptop.brightnessDir;

        enable-scroll = "true";

        format = "󰃠 <bar>";

        bar-width = "10";
        bar-indicator = "|";
        bar-fill = "─";
        bar-empty = "─";
      };

      "module/date" = {
        type = "internal/date";

        time = "%A, %B %d %I:%M:%S %p";

        label = "%time%%date%";
        label-padding = "1";
      };

      "module/alsa" = lib.mkIf sysConfig.alsaSupport {
        type = "internal/alsa";

        format-volume = "󱄠 <bar-volume> ";
        format-muted = "󰝟 <bar-volume> ";

        bar-volume-width = "10";
        bar-volume-indicator = "|";
        bar-volume-fill = "─";
        bar-volume-empty = "─";
      };


      "module/mpd" = {
        type = "internal/mpd";

        host = "127.0.0.1";
        port = "6600";

        interval = "2";

        format-online = "<icon-prev>  <toggle>  <icon-next> <label-time>";
        label-offline = "mpd is offline";
        format-offline = "<label-offline>";

        icon-play = "";
        icon-pause = "";
        icon-prev = "";
        icon-next = "";
        icon-seekb = "";
        icon-seekf = "";
        icon-random = "";
        icon-repeat = "";
      };

      "module/polydoro" =
        let
          polydoroPath = "${pkgs.polydoro.outPath}/bin/polydoro";
        in
        {
          type = "custom/script";

          exec = "${polydoroPath} run --paused-icon \" %{F${colors.red}}%{F-} \" -f";
          tail = "true";

          label = "%output%";
          click-left = "${polydoroPath} toggle";
          click-right = "${polydoroPath} skip";
        };

      "module/battery" = lib.mkIf (laptop != null) {
        type = "internal/battery";
        full-at = "99";
        low-at = "10";

        battery = laptop.battery;
        adapter = laptop.adapter;
        poll-interval = "5";

        format-charging = "󰂄 <label-charging>";
        format-charging-padding = "1";

        format-discharging = "<ramp-capacity>  <label-discharging>";
        format-discharging-padding = "1";

        format-full = "<ramp-capacity>  <label-full>";
        format-full-padding = "1";

        format-low-padding = "1";

        label-discharging = "%percentage%%";
        label-charging = "%percentage%%";
        label-full = "%percentage%%";

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
      };
    };
  };
}
