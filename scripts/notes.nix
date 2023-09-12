pkgs: pkgs.writeShellApplication {
  runtimeInputs = with pkgs; [ gum fd fzf kakoune ];
  name = "dailysh";
  text = with pkgs.lib; ''
        #!/usr/bin/env bash

        while true 
        do
          CHOOSEN=$(${getExe pkgs.fd} --full-path ~/Notes/ --type file --type symlink | ${getExe pkgs.fzf})
        
          if [ "$CHOOSEN" = "Notes/NEW" ]; then
            FILE=$(${getExe pkgs.gum} input --placeholder "New note name? (exclude .md)")
            FILE="Notes/$FILE.md"
            mkdir -p -- "$(dirname -- "$FILE")"
            touch -- "$FILE"
          else
            FILE=$CHOOSEN
          fi

          ${getExe pkgs.kakoune} "$HOME/$FILE"
        done
  '';
}
