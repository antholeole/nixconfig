{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  # TODO: this does not allow args
  commandTab = pkgs.writeText "one-command.kdl" ''
    layout {
      tab name="{{ (ds "in").name }}" {
        pane {
          command "{{ (ds "in").command }}"
        }

        ${config.zjstatus}
      }
    }
  '';

  upsertTab = pkgs.writeShellApplication {
    name = "upsert-tab";
    runtimeInputs = with pkgs; [zellij gomplate];
    text = ''
      name="$1"
      command="$2"

      if zellij action query-tab-names | grep "$name"; then
          zellij action go-to-tab-name "$1"
          exit 0
      fi

      kdl=$(mktemp "/tmp/XXXXXXXXXXXX.kdl")
      echo "{'name': '$name', 'command': '$command'}" | gomplate -d in=stdin:///in.json -f ${commandTab} > "$kdl";
      zellij action new-tab -l "$kdl";
      rm "$kdl";
    '';
  };
in {
  options = {
    upsertTab = with lib;
      mkOption {
        type = types.package;
        description = mdDoc "upsert-tab package";
        readOnly = true;
        default = upsertTab;
      };
  };
}
