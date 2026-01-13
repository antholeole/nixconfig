{ pkgs, ... }: {
  home.packages = with pkgs; [
    nodejs_24
    biome
    typescript-language-server
    nodePackages.vscode-langservers-extracted
    stylelint-lsp
  ];

  programs.helix.languages = {
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
      ];

    language-server = {
      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
        args = ["--stdio"];
        config = {
          provideFormatter = true;
          css.validate.enable = true;
          scss.validate.enable = true;
        };
      };

      stylelint-ls = {
        command = "stylelint-lsp";
        args = ["--stdio"];
      };

      biome = {
        command = "biome";
        args = ["lsp-proxy"];
      };
    };
  };
}
