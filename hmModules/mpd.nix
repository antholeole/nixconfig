{
  config,
  pkgs,
  ...
}: {
  services.mpd-mpris = {
    enable = !config.conf.headless;
  };

  services.mpd = {
    enable = !config.conf.headless;

    package = pkgs.symlinkJoin {
      name = "mpd-wrapped";
      paths = [pkgs.mpd];
      buildInputs = [pkgs.makeWrapper];

      postBuild = ''
        wrapProgram $out/bin/mpd \
          --run "export ALSA_PLUGIN_DIR=${pkgs.alsa-plugins}/lib/alsa-lib"
      '';
    };

    network.startWhenNeeded = true;

    # only pipewire for now
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire"
      }

      follow_outside_symlinks     "yes"
      follow_inside_symlinks      "yes"
    '';
  };
}
