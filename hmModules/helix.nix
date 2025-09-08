{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  lib,
  ...
}: {
  programs.helix = let
    rust-toolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.default.override {
        extensions = ["rustfmt" "rust-analyzer" "rust-src" "cargo" "rustc"];
        targets = ["x86_64-unknown-linux-gnu"];
      });
    isArm = pkgs.system == "aarch64-linux";
  in {
    package = pkgs.helix;
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; let
      extensionsIf = cond: extensions:
        if cond
        then extensions
        else [];

      headlessPkgsOnly = extensionsIf (config.conf.headless) [
        wl-clipboard
      ];

      x64PkgsOnly = extensionsIf (!isArm) [
        terraform-ls
        starpls-bin
      ];
    in
      [
        #cpp
        pkgs-unstable.llvmPackages_20.clang-tools
        pkgs-unstable.lldb_20

        # nix
        alejandra
        nil

        # scala
        metals

        # go
        gopls
        go

        # python
        basedpyright
        ruff

        # qml... pretty big. we should remove it
        kdePackages.qtdeclarative

        # js
        biome
        typescript-language-server
        vscode-langservers-extracted
        stylelint-lsp

        # rust
        rust-toolchain

        # protobuf
        buf

        # other
        config.programs.git.package
      ]
      ++ headlessPkgsOnly
      ++ x64PkgsOnly;

    settings = {
      theme = "gruvbox";

      keys = {
        normal = {
          ret = "goto_word";
          space = {
            F = "file_picker";
            f = "file_picker_in_current_buffer_directory";
            E = "file_explorer";
            e = "file_explorer_in_current_buffer_directory";

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
      in
        [
          (mkBiomeFmt "typescript-language-server" "javascript")
          (mkBiomeFmt "typescript-language-server" "typescript")
          (mkBiomeFmt "typescript-language-server" "jsx")
          (mkBiomeFmt "typescript-language-server" "tsx")

          (mkBiomeFmt "json-language-server" "json")
          (mkBiomeFmt "json-language-server" "json5")

          {
            name = "css";
            file-types = ["css" "less"];
            language-servers = ["stylelint-ls"];
          }
          {
            name = "scss";
            language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
          }
          {
            name = "python";
            language-servers = [
              "basedpyright"
              "ruff"
            ];
          }
          {
            name = "starlark";
            language-servers = [
              "starpls"
            ];
            formatter = {
              command = "${pkgs.bazel-buildtools}/bin/buildifier";
              args = ["--mode=fix"];
            };
          }
        ]
        ++ (
          if isArm
          then []
          else [
            {
              name = "hcl";
              language-servers = ["terraform-ls"];
              formatter = {
                command = "${pkgs.terraform}/bin/terraform";
                args = ["fmt" "-"];
              };
            }
          ]
        );

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
        args = ["--stdio"];
        config = {
          provideFormatter = true;
          css.validate.enable = true;
          scss.validate.enable = true;
        };
      };

      language-server = {
        basedpyright = {
          command = "basedpyright-langserver";
          args = ["--stdio"];
          except-features = ["format"];

          config."basedpyright.analysis.diagnosticMode" = "openFilesOnly";
        };

        qmlls = {
          name = "qmlls";
          command = "qmlls";
          args = ["-E"];
        };

        ruff = {
          command = "ruff";
          args = ["server"];
        };

        rust-analyzer.command = "rust-analyzer";
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
        terraform-ls = lib.mkIf (!isArm) {
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
