{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (!config.conf.work) {
  home.packages = [
    pkgs.nur.repos.charmbracelet.crush
  ];

  xdg.configFile."crush/crush.json" = {
    enable = true;
    text = builtins.toJSON {
      "$schema" = "https=//charm.land/crush.json";
      "permissions" = {
        "allowed_tools" = [
          "view"
          "ls"
          "grep"
          "edit"
        ];
      };
    };
  };
}
