{
  pkgs-unstable,
  config,
  lib,
  ...
}: {
  home.packages = lib.mkIf (builtins.elem "minecraft" config.conf.features) [
    pkgs-unstable.prismlauncher
  ];
}
