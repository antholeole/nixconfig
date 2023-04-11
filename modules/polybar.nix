{ pkgs, ... }: 
let 
    # based on Catpuccin
    colors = {
        base = "#303446";
        mantle = "#292c3c";
        crust = "#232634";

        text = "#c6d0f5";
        subtext0 = "#a5adce";
        subtext1 = "#b5bfe2";

        surface0 = "#414559";
        surface1 = "#51576d";
        surface2 = "#626880";

        overlay0 = "#737994";
        overlay1 = "#838ba7";
        overlay2 = "#949cbb";

        flamingo = "#eebebe";
    };

    seperator = {
        type = "custom/text";
        content = "|"; 
        content-foreground = colors.subtext0;
    };
in {
    home-manager.users.anthony.services.polybar = {
    enable = true;
    script = "polybar bar &";

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

            modules-left = [ "brightness" "polypomo" ];
            modules-right = [ "battery" "sep1" "date" ];

            font-0 = "FiraCode Nerd Font:weight=200:pixelsize=18";
        };

        "module/sep1" = seperator;
        "module/sep2" = seperator;

        "module/brightness" = {
            type = "internal/backlight";
            card = "gpio-bl";

            enable-scroll = "true";

            format = "󰃠 <bar><label>";

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

        "module/polypomo" = let 
            polypomoPath = "${pkgs.polypomo.outPath}/bin/polypomo";
        in {
            type = "custom/script";

            exec = "${polypomoPath}";
            tail = "true";
            
            label = "%output%";
            click-left = "${polypomoPath} toggle";
            click-right = "${polypomoPath} end";
            click-middle = "${polypomoPath} lock";
            scroll-up = "${polypomoPath} time +60";
            scroll-down = "${polypomoPath} time -60";
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