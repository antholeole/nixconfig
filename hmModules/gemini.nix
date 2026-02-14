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
        # preferredEditor = "${config.programs.helix.package}/bin/hx";
        disableUpdateNag = true;

        tools.enableHooks = true;
        hooks = let
          tool = [
            {
              matcher = "*";
              hooks = [{
                name = "notify";
                type = "command";
                command = let
                  remoteClipClient =
                    (import "${inputs.self}/programs/clipboard" pkgs).client;

                  notify = pkgs.writeShellScriptBin "gem-notify" ''
                    echo "gemini needs input for $GEMINI_CWD!" | ${remoteClipClient.notify}
                  '';
                in "${notify}/bin/gem-notify";
                description = "notify gemini execution end";
              }];
            }
          ];
        in {
          enabled = true;

          AfterAgent = tool;
          Notification = tool;
        };
      };
    };
  };
}
