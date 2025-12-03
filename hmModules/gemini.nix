{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}: {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "gemini-cli";
      buildInputs = [pkgs.makeWrapper];
      paths = [
        (
          if config.conf.work
          then pkgs.writeShellScriptBin "gemini" "/google/bin/releases/gemini-cli/tools/gemini"
          else pkgs-unstable.gemini-cli
        )
      ];

      postBuild = ''
        wrapProgram $out/bin/gemini \
          --set COLORTERM truecolor
      '';
    };

    defaultModel = "gemini-3-pro-preview";

    settings = {
      general = {
        enablePreviewFeatures = true;
        preferredEditor = "${config.programs.helix.package}/bin/hx";
        disableUpdateNag = true;
      };

      mcpServers = {
        serena = {
          command = "${pkgs.symlinkJoin {
            name = "serena-wrapped";
            paths =
              (import "${inputs.self}/shared/lsps.nix" pkgs config)
              ++ [pkgs.serena];
          }}/bin/serena";

          args = [
            "start-mcp-server"
          ];
        };
      };
    };
  };
}
