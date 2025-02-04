{
  pkgs,
  config,
  ...
}: {
  programs.helix = {
    package = pkgs.helix;
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      alejandra
      nil
      metals
      gopls
    ];

    settings = {
      theme = "gruvbox";

      keys = {
        normal = {
          ret = "goto_word";
        };
      };

      editor = {
        line-number = "relative";
        rulers = [80];
        jump-label-alphabet = "hjklabcdefgimnopqrstuvwxyz";
        soft-wrap.enable = true;
        true-color = true;

        # TODO: add some clipboard providers

        lsp = {
          display-inlay-hints = true;
        };

        auto-save.after-delay.timeout = 3000;

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };

        clipboard-provider =
          if (!config.conf.headless)
          then "wayland"
          else {
            custom = with config.programs.system-clip; {
              # TODO: not working but compiles
              yank = {command=package; args=["paste"];};
              paste= {command=package; args=["paste"];};
            };
          };
      };
    };

    languages = {
      language = [];

      language-server = {
        nil = {
          command = "nil";
          config.nil.formatting.command = ["alejandra" "-q"];
        };
      };
    };
  };
}
