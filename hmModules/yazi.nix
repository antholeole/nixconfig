{
  inputs,
  config,
  pkgs-unstable,
  ...
}: {
  programs.yazi = {
    package = pkgs-unstable.yazi;
    enable = true;
    enableFishIntegration = true;

    keymap = {
      input.prepend_keymap = [
        {
          run = "close";
          on = ["<C-q>"];
        }
        {
          run = "close --submit";
          on = ["<Enter>"];
        }
        {
          run = "escape";
          on = ["<Esc>"];
        }
        {
          run = "backspace";
          on = ["<Backspace>"];
        }
      ];
      manager.prepend_keymap = [
        {
          run = "escape";
          on = ["<Esc>"];
        }
        {
          run = "quit";
          on = ["q"];
        }
        {
          run = "close";
          on = ["<C-q>"];
        }
      ];
    };

    settings = {
      manager = {
        ratio = [1 2 5];
        sort_dir_first = true;
        linemode = "mtime";
      };
      opener = {
        edit = [
          {
            run = "${config.programs.kakoune.package}/bin/kak $@";
            block = true;
          }
        ];
      };
    };
  };

  xdg.configFile = {
    "yazi/theme.toml".source = inputs.catppuccin-yazi.outPath + "/themes/macchiato.toml";
    "yazi/Catppuccin-macchiato.tmTheme".source = inputs.catppuccin-bat.outPath + "/themes/Catppuccin Macchiato.tmTheme";
  };
}
