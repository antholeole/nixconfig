{ pkgs, ... }: {
  home.packages = let
    ntc = (pkgs.writeShellApplication {
      name = "zrc";
      runtimeInputs = with pkgs; [ zellij ];

      text = let
        # For now, create four of the same pane. it's a good enough number that
        # doesn't take up the whole screen and should be enough.
        elements = 4;
      in ''
        paneStr="";

        for ((n=0;n<${builtins.toString elements};n++)); do
            paneStr="''${paneStr}cmd\n";
        done

        command="$1" 
        args="''${*:1}"

        kdl=$(mktemp "/tmp/XXXXXXXXXXXX.kdl")

        sed -e "s/COMMAND/$command/g" -e "s/ARGS/$args/g" -e "s/REPEAT_ME/$paneStr/g" ~/.config/zellij/layouts/templates/ct.kdl > "$kdl";

        zellij action new-tab -l "$kdl";

        rm "$kdl";
      '';
    });

  in [ ntc ];
}
