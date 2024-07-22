{ pkgs, lib, config, ... }: {
    options.packages.notes = {
        package =  lib.mkOption {
        type = lib.types.package;
        default = pkgs.writeShellScriptBin "notes" ''
	cd ~/Notes/

        options=$(${pkgs.fd}/bin/fd . -e md)
        options="$options"$'\n'"NEW"

        selected=$(echo "$options" | ${pkgs.fzf}/bin/fzf  --bind one:accept)


        case "$selected" in
         NEW)
            file="~/Notes"
         ;;
         "")
          exit 0
         ;;
         *)
            file="$selected"
         ;;
        esac


        ${config.programs.my-kakoune.package}/bin/kak "$file"
        '';
      };
    };
}
