{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  remoteClipClient =
    (import "${inputs.self}/confs/services/clipboard" pkgs).client;
in {
  options.programs.system-clip = lib.options.mkOption {
    type = lib.types.submodule {
      options = {
        copy = lib.options.mkOption {
          type = lib.types.str;
          description = "the command that should be used to copy.";
        };

        paste = lib.options.mkOption {
          type = lib.types.str;
          description = "the command that should be used to paste.";
        };
        package = lib.options.mkOption {
          type = lib.types.str;
          description = "the raw systemclip command. only enabled on headless.";
        };
      };
    };
  };

  config.programs.system-clip = {
    paste =
      if config.conf.headless
      then remoteClipClient.paste
      else "${pkgs.wl-clipboard.outPath}/bin/wl-paste";
    copy =
      if config.conf.headless
      then remoteClipClient.copy
      else "${pkgs.wl-clipboard.outPath}/bin/wl-copy";
    package = lib.mkIf (config.conf.headless) remoteClipClient.package;
  };

  config.systemd.user.services.remoteClip = lib.mkIf (!config.conf.headless) {
    Unit = {Description = "a remote clipboard server";};
    Install.WantedBy = ["graphical-session.target"];

    Service = let
      remoteClipServer =
        (import "${inputs.self}/confs/services/clipboard" pkgs).server;
    in {
      Environment = "GIN_MODE=release";
      ExecStart = with pkgs; "${remoteClipServer}/bin/rcserver --wlcopy ${wl-clipboard.outPath}/bin/wl-copy --wlpaste ${wl-clipboard.outPath}/bin/wl-paste --notify-send ${libnotify}/bin/notify-send";
    };
  };
}
