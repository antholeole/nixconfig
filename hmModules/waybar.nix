{ pkgs, sysConfig, lib, ... }:
let colors = import ../theme.nix;
in with sysConfig; {
  programs.waybar = lib.mkIf (!sysConfig.headless) {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left =
          [ "sway/workspaces" "brightness" "alsa" "custom/polydoro" ];
        modules-center = [ "custom/mpd-prev" "mpd" "custom/mpd-next" ];
        modules-right = (if laptop != null then [ "battery" ] else [ ])
          ++ [ "clock" ];

        "clock" = {
          type = "internal/date";
          format = "{:%A, %B %d %I:%M:%S %p}";
          timezone = "US/Pacific";
          interval = 1;
        };

        "battery" = lib.mkIf (laptop != null) {
          full-at = "98";
          low-at = "10";

          format = "{icon}  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          format-charging = "󰂄 {capacity}%";
          format-full = " ";
          interval = 30;

          states = {
            "warning" = 25;
            "critical" = 10;
          };

          tooltip = false;
        };

        "custom/polydoro" = let polydoroPath = "${pkgs.polydoro}/bin/polydoro";
        in {
          exec = "${polydoroPath} run -f";
          exec-on-event = false;

          on-click = "${polydoroPath} toggle";
          on-click-right = "${polydoroPath} skip";
        };

        "custom/mpd-prev" = {
          format = "󰒮";
          on-click = "${pkgs.mpc-cli}/bin/mpc prev";
        };

        "custom/mpd-next" = {
          format = "󰒭";
          on-click = "${pkgs.mpc-cli}/bin/mpc next";
        };
      };
    };

    style = with colors; ''
      * {
      font-family: '${font}', monospace;
        font-size: 12px;
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: ${text};
        margin: 5px 5px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: ${surface0};
        margin-left: 1rem;
      }

      #workspaces button {
        color: ${lavender};
        border-radius: 1rem;
        padding: 0.4rem;
      }

      #workspaces button.focused {
        color: ${flamingo};
        border-radius: 1rem;
      }


      #tray,
      #clock,
      #battery,
      #pulseaudio,
      #custom-polydoro,
      #mpd {
        background-color: ${surface0};
        padding: 0.5rem 1rem;
        border-radius: 1rem;
        margin: 5px 10px;
      }
    '';
  };
}
