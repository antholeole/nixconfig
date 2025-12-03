{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}: {
  programs.gemini-cli = {
    package =
      pkgs-unstable.gemini-cli;

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
              (import "${inputs.self}/shared/lsps.nix" pkgs)
              [pkgs.sernea];
          }}/bin/serena";
        };
      };
    };
  };
}
