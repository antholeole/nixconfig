{ pkgs, ... }: {
  home.packages = let
    ntc = (pkgs.writeShellApplication {
      name = "command-tab";
      runtimeInputs = with pkgs; [ zellij gomplate ];

      text = let
      in ''
        command="$1" 
        args="''${*:2}"
        kdl=$(mktemp "/tmp/XXXXXXXXXXXX.kdl")

        echo "{'command': '$command', 'args': '$args'}" | gomplate -d in=stdin:///in.json -f ~/.config/zellij/layouts/templates/command-tab.kdl > "$kdl";

        zellij action new-tab -l "$kdl";

        rm "$kdl";
      '';
    });

  in [ ntc ];
}
