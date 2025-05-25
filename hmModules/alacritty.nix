{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  programs.alacritty = lib.mkIf (!config.conf.headless) {
    enable = true;

    package = config.lib.nixGL.wrap pkgs.alacritty;

    settings = {
      font = {
        normal = {family = config.font;};
        size = 10;
      };

      general.import = [
        "${inputs.gruvbox-alacritty}/themes/gruvbox_material_medium_dark.toml"
      ];

      terminal.shell = "${pkgs.lib.getExe config.programs.fish.package}";

      window.padding = {
        x = 5;
        y = 5;
      };

      keyboard.bindings = [
        {
          key = "`";
          mods = "Control";
          chars = "\\u001b\\u005b\\u0032\\u0033\\u007e";
        }
      ];
    };
  };
}
