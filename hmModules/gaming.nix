{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    lib.mkIf (builtins.elem "gaming" config.conf.features) [
            xwayland-satellite
            gamescope
    ];
}
