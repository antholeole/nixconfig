{config, pkgs, sysConfig, mkNixGLPkg, inputs, ...}: let
    nixGlHyprland = mkNixGLPkg pkgs.hyprland pkgs.hyprland.meta.mainProgram;
in {
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
    }

    # when holding alt + space, we should show the numbers
    bind=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = true"
    bindr=ALT,SPACE,exec,${agsExe} --run-js "altDown.value = false"

    bind = ${mod},G,exec,${pkgs.lib.getExe (mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram)}
    bind = ${mod},W,killactive

    # binds workspace keys
    ${builtins.concatStringsSep "\n" (builtins.genList (
        i: let
          iStr = builtins.toString i;
        in ''
          bind = ${mod}, ${iStr}, workspace, ${iStr}
          bind = ${mod} SHIFT, ${iStr}, movetoworkspace, ${iStr}
        ''
      )
      10)}
  '';
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
