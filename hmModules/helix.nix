{
  pkgs,
  config,
  inputs,
  ...
}: {
  programs.helix = {
    package = pkgs.helix;
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs;
      [
        llvmPackages_19.clang-tools
        alejandra
        nil
        metals
        gopls
        ruff
        biome
        typescript-language-server
        vscode-langservers-extracted
        terraform-ls
        starpls-bin
        stylelint-lsp
        python3Packages.python-lsp-server

        config.programs.git.package
      ]
      ++ (
        if (!config.conf.headless)
        then [
          wl-clipboard
        ]
        else []
      );

    settings = {
      theme = "gruvbox";

      keys = {
        normal = {
          ret = "goto_word";
          space = {
            F = "file_picker";
            f = "file_picker_in_current_buffer_directory";

            space = {
              b = ":sh git blame -L %{cursor_line},%{cursor_line} %{buffer_name}";
            };
          };
        };
      };

      editor = {
        line-number = "relative";
        rulers = [80];
        jump-label-alphabet = "hjklabcdefgimnopqrstuvwxyz";
        soft-wrap.enable = true;
        true-color = true;
        cursorline = true;

        file-picker = {
          # always show hidden files, these are often useful
          hidden = false;
          # do not respect the gitignore; its helpful to see generated files.
          git-ignore = false;
          # do respect our manual ignore files.
          ignore = true;
        };

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
              yank = {
                command = package;
                args = ["paste"];
              };
              paste = {
                command = package;
                args = ["copy"];
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
        {
          name = "hcl";
          language-servers = ["terraform-ls"];
          formatter = {
            command = "${pkgs.terraform}/bin/terraform";
            args = ["fmt" "-"];
          };
        }

        {
          name = "css";
          file-types = ["css" "scss" "less"];
          language-servers = ["stylelint-ls"];
        }
          {
            name = "python";
            language-servers = [
              "pylsp"
            ];
          }
      ];

      language-server = {
        rust-analyzer.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        clangd = {
          args = [
            "--enable-config"
            "--clang-tidy"
          ];
        };
        
        stylelint-ls = {
          command = "stylelint-lsp";
          args = ["--stdio"];
        };

        nil = {
          command = "nil";
          config.nil.formatting.command = ["alejandra" "-q"];
        };

        biome = {
          command = "biome";
          args = ["lsp-proxy"];
        };
        terraform-ls = {
          command = "terraform-ls";
          # https://github.com/helix-editor/helix/discussions/9630
          args = ["serve" "-log-file" "/dev/null"];
        };
      };
    };

    ignores = import "${inputs.self}/shared/ignores.nix";
  };

  xdg.configFile."clangd/config.yaml".text = ''
CompileFlags:
  Add: [-Wall, -std=c++2b, -Wsuggest-override]
  '';
}
