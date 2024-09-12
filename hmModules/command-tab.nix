{
  pkgs,
  inputs,
  config,
  sysConfig,
  ...
}: {
  home.packages = let
    ntc = pkgs.writeShellApplication {
      name = "command-tab";
      runtimeInputs = with pkgs; [zellij gomplate];

      text = let
        zjStatus = (import "${inputs.self}/shared/zjstatus.nix") pkgs sysConfig;
        commandTab = pkgs.writeText "command-tab.kdl" ''
          layout {
            pane_template name="cmd" {
              command "/bin/bash"
              args "-c" {{ strings.Quote (ds "in").both }}
            }

            tab name={{ strings.Quote (ds "in").command }} {
          	pane stacked=true {
              {{ range seq 4 1 }}cmd
              {{ end }}
          	}

            ${zjStatus}
            }
          }
        '';
      in ''
        command="$1"
        args="''${*:2}"
        kdl=$(mktemp "/tmp/XXXXXXXXXXXX.kdl")

        echo "{'command': '$command', 'args': '$args', 'both': '$command $args'}" | gomplate -d in=stdin:///in.json -f ${commandTab} > "$kdl";

        zellij action new-tab -l "$kdl";

        rm "$kdl";
      '';
    };
  in [ntc config.upsertTab];
}
