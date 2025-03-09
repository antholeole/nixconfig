{inputs, config, ...}: {
  programs.waybar = {
    enable = !config.conf.headless;
    settings = builtins.fromJSON (builtins.readFile "${inputs.self}/confs/waybar/config.json");
    style = builtins.readFile "${inputs.self}/confs/waybar/style.css";

    # just enable it directly from niri
    systemd.enable = false;
  };
}
