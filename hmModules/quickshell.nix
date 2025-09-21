{self, pkgs, config, ...}: {
  programs.quickshell = let
    defaultConfig = "default";
  in {
    package = pkgs.symlinkJoin {
      name = "quickshell";
      paths = with pkgs; [
        config.programs.niri.package

        quickshell
      ];
    };
    enable = true;
    activeConfig = defaultConfig;
    systemd.enable = true;
    configs = {
      ${defaultConfig} = "${self}/confs/quickshell";
    };
  };
}
