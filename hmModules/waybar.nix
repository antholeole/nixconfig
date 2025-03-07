{...}: {
  programs.waybar = {
    enable = true;
    settings = [{
      topBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
        "niri/workspaces"
        ];

        modules-right = [
          "battery"
        ];

        battery = {
    interval = 60;
    states = {
        "warning" = 30;
        "critical" = 10;
    };
    "format" = "{capacity}% {icon}";
    "format-icons" = ["", "", "", "", ""];
    "max-length" = 2;
        };
      };
    }];
  };
}
