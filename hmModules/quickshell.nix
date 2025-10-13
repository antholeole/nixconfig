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
    enable = config.conf.headless && !config.conf.darwin;
    activeConfig = defaultConfig;
    systemd.enable = true;
    configs = {
      ${defaultConfig} = "${self}/confs/quickshell";
    };
  };
}
