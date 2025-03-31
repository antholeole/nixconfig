{
  pkgs,
  inputs,
  config,
  lib,
  ...
} @ params: {
  programs.alacritty = lib.mkIf (!config.conf.headless) {
    enable = true;

    package = lib.mkIf (!config.conf.nixos)
    # if we're on nixos, use the default pkgs.alacritty. otherwise, use
    # nixgl alacritty.
      (params.mkNixGLPkg pkgs.alacritty "alacritty")
      // (with pkgs.alacritty; {inherit meta version;});

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
