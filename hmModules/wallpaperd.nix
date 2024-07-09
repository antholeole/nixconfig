{ inputs, sysConfig, lib, ... }: {
  home.file."backgrounds" = {
    enable = !sysConfig.headless;
    source = "${inputs.self}/confs/bgs";
  };

  programs.wpaperd = {
    enable = !sysConfig.headless;
    settings = let
      monitors = [ "default" "any" "eDP-1" "DP-2" "HDMI-A-1" ];

      settings = {
        sorting = "random";
        mode = "fit-border-color";
        duration = "1h";
        path = "~/backgrounds";
      };
    in lib.attrsets.mergeAttrsList
    (builtins.map (monitor: { "${monitor}" = settings; }) monitors);
  };
}

