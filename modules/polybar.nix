{ pkgs, inputs, ... }: 
let
    colors = import ../theme.nix;
    seperator = {
        type = "custom/text";
        content = "|"; 
        content-foreground = colors.subtext0;
    };
in {
    home-manager.users.anthony.services.polybar = {
    enable = true;
    script = "polybar bar &";

    package = pkgs.polybar.override {
        mpdSupport = true;
        alsaSupport = true;
    };

    config = {
        "bar/bar" = {
            width = "100%";
            height = "40pt";
            offset-x = "0";
            offset-y = "0";
            
            background = "${colors.mantle}";
            foreground = "${colors.text}";
            line-size = "3pt";
            padding-left = "1";
            padding-right = "0";

            modules-left = [ "brightness" "alsa" "polydoro" ];
            modules-center = [ "mpd" ];
            modules-right = [ "battery" "sep1" "date" ];

            font-0 = "FiraCode Nerd Font:weight=200:pixelsize=18";
        };

        "module/sep1" = seperator;
        "module/sep2" = seperator;

        "module/brightness" = {
            type = "internal/backlight";
            card = "gpio-bl";

            enable-scroll = "true";

            format = "󰃠 <bar>";

            bar-width = "10";
            bar-indicator = "|";
            bar-fill = "─";
            bar-empty = "─";
        };

        "module/date" = {
            type = "internal/date";

            time = "%A, %d %B %Y %I:%M %p";

            label = "%time%%date%";
            label-padding = "1";
        };

        "module/alsa" = {
            type = "internal/alsa";
            format-volume = "󱄠 <bar-volume> ";

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

            format-online = "<icon-prev>   <toggle>   <icon-next> <label-time>";
            label-offline = "mpd is offline";

            icon-play = "";
            icon-pause = "";
            icon-prev = "";
            icon-next = "";
            icon-seekb = "";
            icon-seekf = "";
            icon-random = "";
            icon-repeat = "";
        };

        "module/polydoro" = let 
            polydoroPath = "${pkgs.polydoro.outPath}/bin/polydoro";
        in {
            type = "custom/script";

            exec = "${polydoroPath} run";
            tail = "true";
            
            label = "%output%";
            click-left = "${polydoroPath} toggle";
            click-right = "${polydoroPath} skip";
        };

        "module/battery" = {
            type = "internal/battery";
            full-at = "99";
            low-at = "10";

            battery = "macsmc-battery";
            adapter = "macsmc-ac";
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

#{ pkgs, ... }: {
    # want: 
    # right: battery, time
    # center: music player, sound
    # left: brightness slider, pomodoro

#}