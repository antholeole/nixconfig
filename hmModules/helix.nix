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
        # nix
        alejandra
        nil

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
        config.programs.yazi.package
      ]
      ++ headlessPkgsOnly
      ++ x64PkgsOnly;

    settings = {
      theme = "github_dark";

      keys = {
        normal = {
          ret = "goto_word";
          C-s = ":write";
          space = {
            q = {
              q = ":quit-all";
              s = ":write-quit-all";
              f = ":quit-all!";
            };

            E = [
              ":sh rm -f /tmp/unique-file"
              ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
              ":insert-output echo \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
              ":open %sh{cat /tmp/unique-file}"
              ":redraw"
            ];

            e = "file_explorer_in_current_buffer_directory";

            space = {
              b = ":sh git blame -L %{cursor_line},%{cursor_line} %{buffer_name}";
            };
          };
        };
        insert = {
          j = {
            j = "normal_mode";
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
        mouse = false;
        default-yank-register = "+";
        bufferline = "multiple";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          # always show hidden files, these are often useful
          hidden = false;
          # do not respect the gitignore; its helpful to see generated files.
          git-ignore = false;
          # do respect our manual ignore files.
          ignore = true;
        };

        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name" "file-modification-indicator"];
          right = [
            "diagnostics"
            "version-control"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
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
          then
            (
              if (!config.conf.darwin)
              then "wayland"
              else "pasteboard"
            )
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

    themes = {
      github_dark = let
        transparent = "none";
        bg = "#0d1117";
        bg_dim = "#010409";
        bg_hover = "#161b22";
        sel = "#3c4a5d";
        fg = "#c9d1d9";
        fg_dim = "#5d626e";
        muted = "#8b949e";
        gutter = "#6e7681";
        ruler = "#484f58";
        blue = "#79c0ff";
        blue_alt = "#a5d6ff";
        purple = "#bc8cff";
        green = "#2ea043";
        green_alt = "#7ee787";
        orange = "#ffa657";
        keyword_red = "#ff7b72";
        error_red = "#ffa198";
        warn_yellow = "#d29922";
        window_edge = "#0d1117";
      in {
        # GENERAL
        "warning" = {fg = warn_yellow;};
        "error" = {fg = error_red;};
        "diagnostic" = {modifiers = ["underlined"];};
        "info" = {fg = blue_alt;};
        "hint" = {fg = green_alt;};

        # UI
        "ui.background" = {
          bg = bg;
          fg = fg;
        };
        "ui.text" = {fg = fg;};
        "ui.help" = {
          bg = bg_dim;
          fg = fg;
        };
        "ui.window" = {fg = window_edge;};
        "ui.popup" = {
          bg = bg_dim;
          fg = fg;
        };
        "ui.menu" = {
          bg = bg_dim;
          fg = fg;
        };
        "ui.menu.selected" = {bg = bg_hover;};
        "ui.statusline" = {fg = fg;};
        "ui.linenr" = {fg = gutter;};
        "ui.linenr.selected" = {fg = fg;};
        "ui.virtual" = {
          fg = fg_dim;
          modifiers = ["bold"];
        };
        "ui.virtual.ruler" = {bg = ruler;};
        "ui.virtual.whitespace" = {fg = ruler;};
        "ui.selection" = {bg = sel;};
        "ui.selection.primary" = {bg = sel;};
        "ui.cursor" = {modifiers = ["reversed"];};
        "ui.cursor.primary" = {modifiers = ["reversed"];};
        "ui.cursor.match" = {
          fg = green;
          modifiers = ["underlined" "bold"];
        };
        "ui.cursorline.primary" = {bg = bg_dim;};

        # SYNTAX HIGHLIGHTING
        "comment" = {
          fg = muted;
          modifiers = ["italic"];
        };
        "constant" = {fg = blue;};
        "constant.character.escape" = {fg = blue_alt;};
        "function" = {fg = purple;};
        "function.macro" = {};
        "keyword" = {fg = keyword_red;};
        "operator" = {fg = blue;};
        "string" = {fg = blue_alt;};
        "string.regexp" = {fg = blue_alt;};
        "type" = {fg = orange;};
        "tag" = {fg = green;};
        "special" = {fg = purple;};

        # MARKUP
        "markup.bold" = {
          fg = fg;
          modifiers = ["bold"];
        };
        "markup.italic" = {
          fg = fg;
          modifiers = ["italic"];
        };
        "markup.heading" = {
          fg = blue;
          modifiers = ["bold"];
        };
        "markup.link" = {
          fg = blue_alt;
          modifiers = ["underline"];
        };
        "markup.quote" = {fg = green_alt;};
        "markup.raw" = {fg = blue;};
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
            formatter.command = "${pkgs.bazel-buildtools}/bin/buildifier";
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

        # we aren't specifying JAVA_HOME; each project probably has its own.
        metals.command = "metals";

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

    ignores = import ../shared/ignores.nix;
  };

  xdg.configFile."clangd/config.yaml".text = ''
    CompileFlags:
      Add: [-Wall, -std=c++2b, -Wsuggest-override]
  '';
}
