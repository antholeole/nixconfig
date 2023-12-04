{ inputs, pkgs, config, systemCopy, sysConfig, lib, ... }: {
    systemd.user.services.remoteClip = {
        Unit = {
            description = "a remote clipboard server";
        };

        Service = let 
            remoteClipServer = (import "${inputs.self}/confs/services/clipboard" pkgs).server;
        in {
          ExecStart = "${remoteClipServer}/bin/server";
        };
    };
}
