{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  mkNixGLPkg,
  inputs,
  ...
}: let
  hyprland = inputs.hyprland.packages."${pkgs.system}".default;

  mouseSize = 24;
in {
  wayland.windowManager.hyprland = let
    mod = "ALT";
    colors = import "${inputs.self}/theme.nix";
    screenshotUtils =
      (import "${inputs.self}/shared/screenshot.nix") pkgs config;

    # wrap with -b hyprags
    agsWrapped = pkgs.symlinkJoin {
      name = "ags-cli-wrapped";
      paths = [
        config.packages.ags-wrapped
      ];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/ags --add-flags "-b hyprags"
      '';
    };

    agsExe = "${agsWrapped}/bin/ags";
    mpcExe = "${pkgs.mpc-cli}/bin/mpc";
    resizeUnit = "30";

    directionKeymap = dir: commandFn:
      (import "${inputs.self}/shared/arrows.nix") {
        inherit dir commandFn lib;
      };
  in {
    enable = !config.conf.headless;
    package = hyprland;

    extraConfig = let
    in ''
      env = HYPRCURSOR_THEME,Vanilla-DMZ
      env = HYPRCURSOR_SIZE,${builtins.toString mouseSize}

      exec-once=${pkgs.wpaperd}/bin/wpaperd >> /tmp/wpaperd.txt &
      exec=sleep 3; ${agsExe} -q ; ${agsExe} >> /tmp/hyprags.txt 2>&1

      # a class for opening windows in floating
      windowrulev2 = float, class:notesfloat


      animation = global,0

      general {
        border_size = 2
        col.active_border = 0xff${config.colorScheme.palette.base02}
        gaps_in = 3
        gaps_out = 5
      }


      # alt space toggles numbers
      bind=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = !altDown.value"

      bind = ${mod},RETURN,exec,${
        pkgs.lib.getExe
        (mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram)
      }  -e ${pkgs.zellij}/bin/zellij a -c "alacritty"

      bind = ${mod},W,killactive

      ${directionKeymap "right" (key: "bind=${mod},${key},movefocus,r")}
      ${directionKeymap "left" (key: "bind=${mod},${key},movefocus,l")}
      ${directionKeymap "down" (key: "bind=${mod},${key},movefocus,d")}
      ${directionKeymap "up" (key: "bind=${mod},${key},movefocus,u")}

      bind=${mod},m,focusmonitor,+1
      bind=SHIFT ${mod},m,movecurrentworkspacetomonitor,+1

      # screenshot stuff
      bindt=ALT_SHIFT,S,exec,${agsExe} --run-js "showScreenshots.value = true;"
      bind=ALT_SHIFT,S,submap,screenshots
      submap=screenshots

      bindt=,s,exec,${screenshotUtils.screenshot}
      bindt=,s,exec,${agsExe} --run-js "showScreenshots.value = false;"
      bind=,s,submap,reset

      bindt=,e,exec,${screenshotUtils.edit}
      bindt=,e,exec,${agsExe} --run-js "showScreenshots.value = false;"
      bind=,e,submap,reset

      bindt=,escape,exec,${agsExe} --run-js "showScreenshots.value = false;"
      bind=,escape,submap,reset
      submap=reset

      # resize
      ${directionKeymap "left"
        (key: "binde=ALT_SHIFT,${key},resizeactive,-${resizeUnit} 0")}
      ${directionKeymap "right"
        (key: "binde=ALT_SHIFT,${key},resizeactive,${resizeUnit} 0")}
      ${directionKeymap "up"
        (key: "binde=ALT_SHIFT,${key},resizeactive,0 -${resizeUnit}")}
      ${directionKeymap "down"
        (key: "binde=ALT_SHIFT,${key},resizeactive,0 ${resizeUnit}")}

      # CONTROL
      bindt=${mod},equal,exec,${agsExe} --run-js "showControl.value = true;"
      bind=${mod},equal,submap,control
      submap=control

      ${directionKeymap "down"
        (key: ''bind=,${key},exec,${agsExe} --run-js "down()"'')}
      ${directionKeymap "up"
        (key: ''bind=,${key},exec,${agsExe} --run-js "up()"'')}
      ${directionKeymap "left"
        (key: ''bind=,${key},exec,${agsExe} --run-js "left()"'')}
      ${directionKeymap "right"
        (key: ''bind=,${key},exec,${agsExe} --run-js "right()"'')}
      bind=,SPACE,exec,${agsExe} --run-js "space()"

      bind=,escape,exec,${agsExe} --run-js "showControl.value = false;"
      bind=,escape,submap,reset
      submap=reset
      # END CONTROL

      # BEGIN FLOATERS
      # if we are in normal mode, we should just let hyprfocus determine
      # if we shold open the window and enter the mode or not.
      bind=${mod},N,exec,${config.packages.notes.hyprfocus}/bin/focus_notes toggle
      submap=floaters

      bind=,w,exec,${agsExe} --run-js "showFloaters.value = false;"
      bind=,w,exec,${config.packages.notes.hyprfocus}/bin/focus_notes taskwarrior ${pkgs.taskwarrior-tui}/bin/taskwarrior-tui
      bind=,w,submap,reset

      bind=,n,exec,${agsExe} --run-js "showFloaters.value = false;"
      bind=,n,exec,${config.packages.notes.hyprfocus}/bin/focus_notes scratch "${config.programs.my-kakoune.package}/bin/kak ~/Notes/scratch.md"
      bind=,n,submap,reset

      bind=,b,exec,${agsExe} --run-js "showFloaters.value = false;"
      bind=,b,exec,${config.packages.notes.hyprfocus}/bin/focus_notes btm ${pkgs.bottom}/bin/btm
      bind=,b,submap,reset

      bind=,t,exec,${agsExe} --run-js "showFloaters.value = false;"
      bind=,t,exec,${config.packages.notes.hyprfocus}/bin/focus_notes terminal "${pkgs.zellij}/bin/zellij a -c scratch"
      bind=,t,submap,reset

      bind=,escape,exec,${agsExe} --run-js "showFloaters.value = false;"
      bind=,escape,submap,reset
      submap=reset
      # END FLOATERS

      # POWERBAR
      bindt=${mod},Q,exec,${agsExe} --run-js "showPowerbar.value = true;"
      bind=${mod},Q,submap,powerbar
      submap=powerbar

      bind=,q,exec,swaylock
      bind=,q,exec,${agsExe} --run-js "showPowerbar.value = false;"
      bind=,q,submap,reset

      bind=,r,exec,reboot
      bind=,l,exec,logout
      bind=,s,exec,poweroff

      bind=,escape,exec,${agsExe} --run-js "showPowerbar.value = false;"
      bind=,escape,submap,reset

      submap=reset

      bindt=${mod},Y,exec,${agsExe} --run-js "showForgot.value = true;"
      bindt=${mod},R,exec,${agsExe} --run-js "showLauncher.value = true;"

      bindtn=,escape,exec,${agsExe} --run-js "showForgot.value = false;" ; ${agsExe} --run-js "showLauncher.value = false;"

      # binds workspace keys
      ${builtins.concatStringsSep "\n" (builtins.genList (i: let
          iStr = builtins.toString i;
        in ''
          bind = ${mod}, ${iStr}, workspace, ${iStr}
          bind = ${mod} SHIFT, ${iStr}, movetoworkspace, ${iStr}
        '')
        10)}


      ${builtins.concatStringsSep "\n" (map (cmd: ''
          exec-once=${cmd}
        '')
        config.conf.wmStartupCommands)}

      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };

    sessionVariables = {
      HYPRCURSOR_THEME = config.home.pointerCursor.name;
      HYPRCURSOR_SIZE = mouseSize;
      XCURSOR_SIZE = mouseSize;
    };

    file.".config/systemd/user/graphical-session.target.wants/xdg-desktop-portal-hyprland.service" = {
      enable = !config.conf.headless;
      source = "${pkgs.xdg-desktop-portal-hyprland}/share/systemd/user/xdg-desktop-portal-hyprland.service";
    };

    file.".config/other/hyprland.desktop" = let
      nixGLHyprland =
        mkNixGLPkg hyprland "Hyprland";
    in {
      enable = !config.conf.headless;
      text = ''
        [Desktop Entry]
        Name=Hyprland
        Comment=Main WM
        Exec=${nixGLHyprland}/bin/hyprland
        Type=Application
      '';
    };
  };
}
