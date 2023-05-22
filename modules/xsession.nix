pkgs: {
  enable = true;
  windowManager.fluxbox = import ./fluxbox;

  initExtra = ''
    setxkbmap -option ctrl:swap_lwin_lctl 
  '';
}