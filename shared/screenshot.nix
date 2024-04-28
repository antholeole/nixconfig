pkgs: config: let 
    lastFileDir = "${config.xdg.stateHome}/last_ss.txt";
in {
    screenshot = pkgs.writeShellScript "screenshot" ''
        out=~/Pictures/$(${pkgs.openssl}/bin/openssl rand -hex 12).png
        ${pkgs.grimblast}/bin/grimblast --notify save area $out
        echo "$out" > ${lastFileDir}
    '';

    edit = pkgs.writeShellScript "edit" "${pkgs.libsForQt5.kolourpaint}/bin/kolourpaint $(cat ${lastFileDir})";
}