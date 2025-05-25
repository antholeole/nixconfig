{
  inputs,
  config,
  pkgs-unstable,
  ...
}: {
  programs.waybar = {
    enable = !config.conf.headless && config.conf.wm;
    package = pkgs-unstable.waybar;
    settings = builtins.fromJSON (builtins.readFile "${inputs.self}/confs/waybar/config.json");
    style = builtins.readFile "${inputs.self}/confs/waybar/style.css";

    # just enable it directly from niri
    systemd.enable = false;
  };
}
