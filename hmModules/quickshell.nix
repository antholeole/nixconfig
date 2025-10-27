{self, pkgs, config, inputs, ...}: {
  programs.quickshell = let
    defaultConfig = "default";
  in {
    package = pkgs.symlinkJoin {
      name = "quickshell";
      paths = [
        config.programs.niri.package

        inputs.quickshell.packages.${pkgs.system}.default
      ];
    };
    enable = !config.conf.headless && !config.conf.darwin;
    activeConfig = defaultConfig;
    systemd.enable = true;
    configs = {
      ${defaultConfig} = "${self}/confs/quickshell";
    };
  };
}
