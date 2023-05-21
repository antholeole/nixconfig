{ config, ... }: 
let 
    colors = import ../theme.nix; 
in {
  home-manager.users.anthony.programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "FiraCode Nerd Font";
        };

        size = 18.0;
      };

      colors = {
        primary = {
          background = colors.base;
          foreground = colors.text;

          dim_foreground = colors.text;
          bright_foreground = colors.text;
        };

        cursor = {
          text = colors.base;
          cursor = colors.flamingo;
        };

        search = {
          matches = {
            foreground = colors.base;
            background = colors.subtext0;            
          };

          focused_match = {
            foreground = colors.base;
            background = colors.green;
          };

          footer_bar = {
            foreground = colors.base;
            background = colors.subtext0;
          };
        };

        hints = {
          start = {
            foreground = colors.base;
            background = colors.yellow;
          };

          end = {
            foreground = colors.base;
            background = colors.subtext0;
          };
        };

        selection = {
          text = colors.base;
          background = colors.flamingo;
        };

        normal = {
          black = colors.surface1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = colors.subtext1;
        };

        bright = {
          black = colors.surface2;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = colors.subtext0;
        };

        dim = {
          black = colors.surface1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = colors.subtext1;
        };
        
      };
    };
  };
}