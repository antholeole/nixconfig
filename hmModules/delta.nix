{pkgs, ...}: {
  programs.delta = {
    enable = true;

    enableGitIntegration = true;
    enableJujutsuIntegration = true;

    package = pkgs.symlinkJoin {
      name = "delta";
      paths = [pkgs.delta];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/delta \
          --set DELTA_PAGER "less -RFX"
      '';

      meta = pkgs.delta.meta;
    };
  };
}
