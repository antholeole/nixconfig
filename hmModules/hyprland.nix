{ config, lib, pkgs, sysConfig, mkNixGLPkg, inputs, ... }:
let nixGlHyprland = mkNixGLPkg pkgs.hyprland pkgs.hyprland.meta.mainProgram;
in lib.mkIf (!sysConfig.headless) {
  wayland.windowManager.hyprland = let
    mod = "ALT";
    colors = import "${inputs.self}/theme.nix";
    agsExe = pkgs.lib.getExe inputs.ags.packages."${pkgs.system}".default;
  in {
    enable = !sysConfig.headless;
    extraConfig = let
    in ''
      animation = global,0

      decoration {
        rounding = 10
        inactive_opacity = 0.8


        drop_shadow = true
        shadow_range = 0
        shadow_offset = 15 15
        shadow_render_power = 0
        col.shadow = 0xff000000
      }

      general {
        border_size = 2
        col.active_border = 0xff000000
        gaps_in = 9
      }

      # when holding alt + space, we should show the numbers
      bind=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = true"
      bindr=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = false"

      bind = ${mod},RETURN,exec,${
        pkgs.lib.getExe
        (mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram)
      }  -e ${pkgs.zellij}/bin/zellij --layout default

      bind = ${mod},W,killactive

      bind=${mod},h,movefocus,l
      bind=${mod},l,movefocus,r
      bind=${mod},k,movefocus,u
      bind=${mod},j,movefocus,d

      bind=${mod},m,focusmonitor,+1
      bind=SHIFT ${mod},m,movecurrentworkspacetomonitor,+1

      bind=ALT_SHIFT,s,exec,${
        pkgs.lib.getExe (pkgs.grimblast)
      } --notify save area ~/Pictures/$(${pkgs.openssl}/bin/openssl rand -base64 12).png


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
      ${builtins.concatStringsSep "\n" (builtins.genList (i:
        let iStr = builtins.toString i;
        in ''
          bind = ${mod}, ${iStr}, workspace, ${iStr}
          bind = ${mod} SHIFT, ${iStr}, movetoworkspace, ${iStr}
        '') 10)}

        
      ${builtins.concatStringsSep "\n" (map (cmd: ''
        exec-once=${cmd}
      '') sysConfig.wmStartupCommands)}

      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      device:AT_Translated_Set_2_keyboard {
        xkb_layout us
        xkb_options caps:swapescape
      }
    '';
  };

  home.file.".config/systemd/user/graphical-session.target.wants/xdg-desktop-portal-hyprland.service" =
    {
      enable = true;
      source =
        "${pkgs.xdg-desktop-portal-hyprland}/share/systemd/user/xdg-desktop-portal-hyprland.service";
    };

  home.file.".config/other/hyprland.desktop" = {
    enable = true;
    text = ''
      [Desktop Entry]
      Name=Hyprland
      Comment=Main WM
      Exec=${pkgs.lib.getExe nixGlHyprland}
      Type=Application
    '';
  };
}
