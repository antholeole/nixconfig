config: {
  # default laptop screen
  "eDP-1" = {
    scale = 2.5;
  };

  # work external monitor
  "Hewlett Packard HP Z27n CNK62212PK" = {
    scale = 1.15;
  };

  "Dell Inc. DELL P3223QE FX9XWN3" = {
    scale = 1.6;
  };

  "Dell Inc. DELL P3225QE G54J484" = {
    scale = 1.6;
  };
   

  # personal monitor
  "Dell Inc. DELL P3223QE 5Y1J2P3" = {
    scale = if config.conf.recording then 3 else 1.6;
  };

  # chicago monitor
  "PNP(AMZ) G24M2020G H513001860" = {
    scale = 1.1;
  };
}
