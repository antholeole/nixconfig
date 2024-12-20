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

              jq
              taskwarrior
              bottom
              zellij
            ];

            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/focus_notes --set PATH $out/bin --add-flags "-b hyprags"
            '';
          };

        bin = pkgs.writeShellScriptBin "focus_notes" ''
          focusedClass=$(hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 0).class')
          notesAddress=$(hyprctl clients -j | jq -r '.[] | select(.class == "notesfloat").address')
          doesExist=$(hyprctl clients -j | jq 'any(.[]; .class == "notesfloat")')
          currentworkspace=$(hyprctl activeworkspace -j | jq -r .name)

          # if it does not exist, we should create it
          if test $doesExist = "false"; then
             echo "notes window does not exist; creating"
             alacritty --class notesfloat -e "taskwarrior-tui" &
             exit 0
          fi

          # if we have it focused we should move it to the scratch output.
          if test "$focusedClass" = "notesfloat"
          then
             echo "notes window exists and is focused: moving to off-screen window"
             hyprctl dispatch movetoworkspacesilent "special:notestab,address:$notesAddress"
             exit 0
          fi

          # otherwise, it exists and is not sed. we should move it to our current workspace.
           echo "notes window exists and is not focused: focusing"
          hyprctl dispatch movetoworkspace "$currentworkspace,address:$notesAddress"
        '';
      in
        wrapWithPkgs bin;
    };
  };
}
