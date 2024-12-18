{
  config,
  lib,
  pkgs,
  mkNixGLPkg,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = let
    mod = "ALT";
    colors = import "${inputs.self}/theme.nix";
    screenshotUtils =
      (import "${inputs.self}/shared/screenshot.nix") pkgs config;
    agsExe = pkgs.lib.getExe inputs.ags.packages."${pkgs.system}".default;
    resizeUnit = "30";

    directionKeymap = dir: commandFn:
      (import "${inputs.self}/shared/arrows.nix") {
        inherit dir commandFn lib;
      };
  in {
    enable = !config.conf.headless;
    # TODO: unpin this version. you MUST change the desktop
    # file below to use a lowercase H or else it will explode.
    # there seems to be a regession between 0.34 and 0.40 that
    # instantly segfaults.
    package =
      (import inputs.nixpkgs-with-hyprland {
        config.allowUnfree = true;
        system = pkgs.system;
      })
      .hyprland;

    extraConfig = let
    in ''
      exec-once=${pkgs.wpaperd}/bin/wpaperd >> /tmp/wpaperd.txt &
      exec=sleep 5; ${agsExe} &

      # a class for opening windows in floating
      windowrulev2 = float, class:notesfloat


      animation = global,0

      decoration {
        rounding = 0

        drop_shadow = false
      }

      general {
        border_size = 2
        col.active_border = 0xff000000
        gaps_in = 3
      }

      bind=${mod},N,exec,${config.packages.notes.hyprfocus}/bin/focus_notes > /tmp/out.txt

      # when holding alt + space, we should show the numbers
      bind=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = true"
      bindr=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = false"

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
      bind=ALT_SHIFT,s,exec,${screenshotUtils.screenshot}
      bind=ALT_SHIFT,e,exec,${screenshotUtils.edit}

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

      bind=,escape,exec,${agsExe} --run-js "showControl.value = false;"
      bind=,escape,submap,reset
      submap=reset
      # END CONTROL

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

  home.file.".config/systemd/user/graphical-session.target.wants/xdg-desktop-portal-hyprland.service" = {
    enable = !config.conf.headless;
    source = "${pkgs.xdg-desktop-portal-hyprland}/share/systemd/user/xdg-desktop-portal-hyprland.service";
  };

  home.file.".config/other/hyprland.desktop" = let
    nixGLHyprland =
      mkNixGLPkg config.wayland.windowManager.hyprland.package "Hyprland";
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
}
