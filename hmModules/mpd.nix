{ lib, sysConfig, ... }: {
  services.mpd = lib.mkIf (!sysConfig.headless) {
    enable = true;

    extraConfig = ''
      follow_outside_symlinks     "yes"
      follow_inside_symlinks      "yes"
    '';
  };
}