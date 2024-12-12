{
  pkgs,
  lib,
  config,
  mkNixGLPkg,
  ...
}: {
  options.packages.notes = {
    hyprfocus = lib.mkOption {
      type = lib.types.package;
      default = let
        hyprctlBin = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
        jqBin = "${pkgs.jq}/bin/jq";
        alacrittyBin = "${
          mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram
        }/bin/alacritty";
      in
        pkgs.writeShellScriptBin "focus_notes" ''
          focusedClass=$(${hyprctlBin} clients -j | ${jqBin} -r '.[] | select(.focusHistoryID == 0).class')
          notesAddress=$(${hyprctlBin} clients -j | ${jqBin} -r '.[] | select(.class == "notesfloat").address')
          doesExist=$(${hyprctlBin} clients -j | ${jqBin} 'any(.[]; .class == "notesfloat")')
          currentworkspace=$(${hyprctlBin} activeworkspace -j | ${jqBin} -r .name)

          # if it does not exist, we should create it
          if test $doesExist = "false"; then
             echo "notes window does not exist; creating"
             ${alacrittyBin} --class notesfloat -e ${config.packages.notes.package}/bin/notes &
             exit 0
          fi

          # if we have it focused we should move it to the scratch output.
          if test "$focusedClass" = "notesfloat"
          then
             echo "notes window exists and is focused: moving to off-screen window"
             ${hyprctlBin} dispatch movetoworkspacesilent "special:notestab,address:$notesAddress"
             exit 0
          fi

          # otherwise, it exists and is not sed. we should move it to our current workspace.
           echo "notes window exists and is not focused: focusing"
          ${hyprctlBin} dispatch movetoworkspace "$currentworkspace,address:$notesAddress"
        '';
    };
  };
}
