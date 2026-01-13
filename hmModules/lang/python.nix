{ pkgs, ... }: {
  home.packages = with pkgs; [
    basedpyright
    ruff
  ];

  programs.helix.languages = {
    language = [
      {
        name = "python";
        language-servers = [
          "basedpyright"
          "ruff"
        ];
      }
    ];

    language-server = {
      basedpyright = {
        command = "basedpyright-langserver";
        args = ["--stdio"];
        except-features = ["format"];

        config."basedpyright.analysis.diagnosticMode" = "openFilesOnly";
      };

      ruff = {
        command = "ruff";
        args = ["server"];
      };
    };
  };
}
