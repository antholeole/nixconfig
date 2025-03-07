{...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      topBar = {
        output = [
          "DP-3"
          "eDP-1"
          "HDMI-A-1"
        ];
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          # "niri/workspaces"
        ];

        modules-right = [
          "battery"
          "clock"
        ];

        battery = {
          interval = 60;
          states = {
            "warning" = 30;
            "critical" = 10;
          };
          "format" = "{capacity}% {icon}";
          "format-icons" = ["" "" "" "" ""];
          "max-length" = 2;
        };

        clock = {
          "format" = "{:%T}";
        };
      };
    };
  };
}
