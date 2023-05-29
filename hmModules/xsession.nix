{ ... }: {
  xsession = {
    enable = true;

    initExtra = ''
      setxkbmap -option ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl 
    '';
  };
}
