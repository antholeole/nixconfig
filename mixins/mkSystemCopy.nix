sysConfig: inputs: pkgs:
if sysConfig.headless then
  (import "${inputs.self}/confs/services/clipboard" pkgs).client.copy
else
  "${pkgs.wl-clipboard.outPath}/bin/wl-copy"
