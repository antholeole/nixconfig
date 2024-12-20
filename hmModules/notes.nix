{
  pkgs,
  lib,
  config,
  mkNixGLPkg,
  ...
}: {
  options.packages.notes = let
    taskwarrior = with pkgs;
      symlinkJoin {
        name = "tw-wrapped";
        paths = [
          taskwarrior-tui
          config.programs.my-kakoune.package
          config.programs.taskwarrior.package
        ];
        buildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/taskwarrior-tui --set EDITOR $out/bin/kak --set PATH $out/bin
        '';
      };
  in {
    hyprfocus = lib.mkOption {
      type = lib.types.package;
      default = let
        hyprctlBin = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
        jqBin = "${pkgs.jq}/bin/jq";
        alacrittyBin = "${
          mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram
        }/bin/alacritty";

        wrapWithPkgs = pkg:
          pkgs.symlinkJoin {
            name = "hyprfocus";
            paths = with pkgs; [
              pkg

              config.programs.alacritty.package
              config.wayland.windowManager.hyprland.package
              config.packages.ags-wrapped

              jq
              taskwarrior
              bottom
              zellij
            ];

            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/focus_notes --set PATH $out/bin
            '';
          };

        bin = pkgs.writeShellScriptBin "focus_notes" ''
          focusedClass=$(hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 0).class')
          notesAddress=$(hyprctl clients -j | jq -r '.[] | select(.class == "notesfloat").address')
          doesExist=$(hyprctl clients -j | jq 'any(.[]; .class == "notesfloat")')
          currentworkspace=$(hyprctl activeworkspace -j | jq -r .name)

          proggy=$1
          bin=$2

          # first, if we  are just running a toggle command, open the query menu if it
          # isn't already open.
          if test "$proggy" = "toggle";
          then
            if test "$focusedClass" = "notesfloat";
            then
               echo "notes window exists and is focused: moving to off-screen window"
               hyprctl dispatch movetoworkspacesilent "special:notestab,address:$notesAddress"
               exit 0
            else
               # the window may or may not exist at this point; open the menu and let hyprland
               # requery with the desired program.
               echo "window is not focused; opening menu!"
               hyprctl dispatch submap "floaters"
               ags -b hyprags --run-js "showFloaters.value = true;"
               exit 0
            fi
          fi

          # if it exists but it is the wrong program, close it and continue like it doesn't
          # exist
          if test $doesExist = "true"; then
            tag=$(hyprctl clients -j | jq -r '.[] | select(.class == "notesfloat").tags[0]')
            if test $tag != "$proggy"; then
              echo "closing window; wrong proggy! wanted $proggy, had $tag"
              hyprctl dispatch closewindow "address:$notesAddress"
            fi
          fi

          # if it does not exist, we should create it
          if test $doesExist = "false"; then
             echo "notes window does not exist; creating"
             alacritty --class notesfloat -e "$bin" &
             sleep 1
             newWindowAddress=$(hyprctl clients -j | jq -r '.[] | select(.class == "notesfloat").address')

             # tag it with the right tag
             echo "tagging address:$newWindowAddress with $proggy"
             hyprctl dispatch tagwindow "+$proggy" "address:$newWindowAddress"
          fi


          # otherwise, it exists and is not sed. we should move it to our current workspace.
           echo "notes window exists and is not focused: focusing"
          hyprctl dispatch movetoworkspace "$currentworkspace,address:$notesAddress"
          hyprctl dispatch focuswindow "address:$notesAddress"
        '';
      in
        wrapWithPkgs bin;
    };
  };
}
