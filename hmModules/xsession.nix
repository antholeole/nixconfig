{ lib, sysConfig, ... }: {
  xsession = lib.mkIf (!sysConfig.headless) {
    enable = true;

    initExtra = ''
      setxkbmap -option ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl,altwin:swap_alt_win 
    '';
  };
}
