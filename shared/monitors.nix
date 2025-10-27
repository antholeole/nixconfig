let
  dellMonitorScale = 2;
  dellMonitorPrefix = "Dell Inc. DELL P3223QE";
  knownDellMonitorsForCLOE = [
    "G54J484"
    "FX9XWN3"
    "5Y1J2P3" # personal
  ];
in
  (
    with builtins;
      listToAttrs (map (v: {
          name = "${dellMonitorPrefix} ${v}";
          value = {
            scale = dellMonitorScale;
          };
        })
        knownDellMonitorsForCLOE)
  )
  // {
    # default laptop screen
    "eDP-1" = {
      scale = 2.5;
    };

    # work external monitor
    "Hewlett Packard HP Z27n CNK62212PK" = {
      scale = 1.15;
    };

    # chicago monitor
    "PNP(AMZ) G24M2020G H513001860" = {
      scale = 1.1;
    };
  }
