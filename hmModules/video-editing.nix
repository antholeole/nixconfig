{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs;
    lib.mkIf (builtins.elem "video-editing" config.conf.features) [
      blender
      ffmpeg_6-full
      v4l-utils
      pkgs-unstable.gphoto2
    ];
}
