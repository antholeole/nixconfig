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
      mgr.prepend_keymap = [
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
            run = "${config.programs.helix.package}/bin/hx $@";
            block = true;
          }
        ];
      };
    };
  };

  xdg.configFile = {
    "yazi/theme.toml".source = inputs.gruvbox-yazi.outPath + "/theme.toml";
  };
}
