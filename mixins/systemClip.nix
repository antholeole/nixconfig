sysConfig: inputs: pkgs:
let

  remoteClipClient =
    (import "${inputs.self}/confs/services/clipboard" pkgs).client;
in if sysConfig.headless then {
  copy = remoteClipClient.copy;
  paste = remoteClipClient.paste;
} else {
  copy = "${pkgs.wl-clipboard.outPath}/bin/wl-copy";
  paste = "${pkgs.wl-clipboard.outPath}/bin/wl-paste";
}

