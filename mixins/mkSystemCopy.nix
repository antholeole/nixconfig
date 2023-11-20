sysConfig: pkgs: if sysConfig.headless then
 with pkgs; "${netcat}/bin/netcat -w 0 localhost 9791"
else
 "${pkgs.wl-clipboard.outPath}/bin/wl-copy"