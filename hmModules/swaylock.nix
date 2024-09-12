{
  pkgs,
  lib,
  sysConfig,
  ...
}: {
  programs.swaylock = lib.mkIf (!sysConfig.headless) {
    enable =
      false; # until https://github.com/NixOS/nixpkgs/issues/158025 is fixed
  };
}
