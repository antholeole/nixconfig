{ inputs, pkgs, config, systemCopy, sysConfig, lib, ... }: {
    systemd.user.services.remoteClip = lib.mkIf (!sysConfig.headless) {
        Unit = {
            Description = "a remote clipboard server";
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = let 
            remoteClipServer = (import "${inputs.self}/confs/services/clipboard" pkgs).server;
        in {
            Environment = "GIN_MODE=release";
            ExecStart = with pkgs; "${remoteClipServer}/bin/oleinaconf.com --cliphist ${cliphist}/bin/cliphist --wlcopy ${wl-clipboard.outPath}/bin/wl-copy --wlpaste ${wl-clipboard.outPath}/bin/wl-paste";
        };
    };
}