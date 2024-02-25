{ pkgs, ... }: {
  programs.helix =
    let
      python-env = pkgs.python311.withPackages (ps: with ps; [
        python-lsp-server
      ] ++ ps.python-lsp-server.optional-dependencies.all);
    in
    {
      enable = true;

      extraPackages = with pkgs; with nodePackages; [
        vscode-langservers-extracted
        gopls
        gotools
        typescript
        typescript-language-server
        marksman
        nil
        nixpkgs-fmt
        clang-tools
        lua-language-server
        rust-analyzer
        bash-language-server
      ];

      languages = {
        language-server.docker-langserver = {
          command = "${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-langserver";
          args = [ "--stdio" ];
        };

        language-server.vscode-html-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
          args = [ "--stdio" ];
          config = {
            provideFormatter = true;
          };
        };

        language-server.gopls = {
          command = "${pkgs.gopls}/bin/gopls";
        };

        language-server.vscode-json-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
          args = [ "--stdio" ];
          config = {
            provideFormatter = true;
            json.validate.enable = true;
          };
        };

        language-server.pylsp = {
          command = "${python-env}/bin/pylsp";
        };

        language-server.metals = {
          command = "${pkgs.metals}/bin/metals";
        };


        language = [
          {
            name = "go";
            auto-format = true;
            formatter.command = "goimports";
          }
          {
            name = "typescript";
            indent.tab-width = 4;
            indent.unit = " ";
            auto-format = true;
          }
          {
            name = "javascript";
            indent.tab-width = 4;
            indent.unit = " ";
            auto-format = true;
          }
          {
            name = "nix";
            formatter.command = "nixpkgs-fmt";
          }
        ];
      };

      settings = {
        theme = "base16_transparent";
      
        keys = {
          normal = {};
        };

        editor = {
          line-number = "relative";
          completion-trigger-len = 1;
          bufferline = "multiple";
          color-modes = true;
          statusline = {
            left = [
              "mode"
              "spacer"
              "diagnostics"
              "version-control"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
              "spinner"
            ];
            right = [
              "file-encoding"
              "file-type"
              "selections"
              "position"
            ];
          };
          cursor-shape.insert = "bar";
          whitespace.render.tab = "all";
          indent-guides = {
            render = true;
            character = "┊";
          };
        };
      };
    };
}
