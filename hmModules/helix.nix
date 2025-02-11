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
      ruff
      biome
      typescript-language-server
      vscode-langservers-extracted
      rust-bin.stable.latest.default
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
              yank = {
                command = package;
                args = ["paste"];
              };
              paste = {
                command = package;
                args = ["paste"];
              };
            };
          };
      };
    };

    languages = {
      language = let
        mkBiomeFmt = ogLsp: name: {
          inherit name;
          language-servers = [
            {
              name = ogLsp;
              except-features = ["format" "inlay-hints"];
            }
            "biome"
          ];
        };
      in [
        (mkBiomeFmt "typescript-language-server" "javascript")
        (mkBiomeFmt "typescript-language-server" "typescript")
        (mkBiomeFmt "typescript-language-server" "jsx")
        (mkBiomeFmt "typescript-language-server" "tsx")

        (mkBiomeFmt "json-language-server" "json")
        (mkBiomeFmt "json-language-server" "json5")
      ];

      language-server = {
        nil = {
          command = "nil";
          config.nil.formatting.command = ["alejandra" "-q"];
        };

        biome = {
          command = "${pkgs.biome}/bin/biome";
          args = ["lsp-proxy"];
        };
      };
    };
  };
}
