{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "gemini-cli";
      buildInputs = [pkgs.makeWrapper];
      paths = let
        # https://github.com/google-gemini/gemini-cli/issues/6146
        gemini-master = with pkgs-unstable;
          gemini-cli.overrideAttrs (finalAttrs: prevAttrs: {
            version = "0.23";

            src = fetchFromGitHub {
              owner = "google-gemini";
              repo = "gemini-cli";
              tag = "v${}";
              rev = "6adae9f7756d8efbc4c5901fe5884fa4a35f1f68";
              hash = "sha256-G1H1M0iYzZkBwwG9KLmqETvacLT0V+9u3ktrgIti2xQ=";
              postFetch = ''
                ${lib.getExe npm-lockfile-fix} $out/package-lock.json
              '';
            };

            npmDeps = fetchNpmDeps {
              inherit (finalAttrs) src;
              hash = "sha256-6PnZlhHk70aPmhIdRIt75rDIQrvZ7aSu6lGJXM6lRjU=";
            };

            dontCheckForBrokenSymlinks = true;
          });
      in [
        (
          if builtins.elem "gbin" config.conf.features
          then pkgs.writeShellScriptBin "gemini" "/google/bin/releases/gemini-cli/tools/gemini"
          else gemini-master
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
    };
  };
}
