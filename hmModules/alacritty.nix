{ pkgs, inputs, config, sysConfig, mkNixGLPkg, lib, ... }:
let
  colors = import ../theme.nix;
in
{
  programs.alacritty = lib.mkIf (!sysConfig.headless) {
    enable = true;

    package = mkNixGLPkg pkgs.alacritty;

    settings = {
      font = {
        normal = { family = "FiraCode Nerd Font"; };

        size = sysConfig.fontSizes.glFontSize;
      };

      colors = with colors; {
        primary = {
          background = base;
          foreground = text;

          dim_foreground = text;
          bright_foreground = text;
        };

        cursor = {
          text = base;
          cursor = flamingo;
        };

        search = {
          matches = {
            foreground = base;
            background = subtext0;
          };

          focused_match = {
            foreground = base;
            background = green;
          };

          footer_bar = {
            foreground = base;
            background = subtext0;
          };
        };

        hints = {
          start = {
            foreground = base;
            background = yellow;
          };

          end = {
            foreground = base;
            background = subtext0;
          };
        };

        selection = {
          text = base;
          background = flamingo;
        };

        normal = {
          black = surface1;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          magenta = pink;
          cyan = teal;
          white = subtext1;
        };

        bright = {
          black = surface2;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          magenta = pink;
          cyan = teal;
          white = subtext0;
        };

        dim = {
          black = surface1;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          magenta = pink;
          cyan = teal;
          white = subtext1;
        };
      };
    };
  };
}
