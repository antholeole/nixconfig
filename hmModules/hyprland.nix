{config, pkgs, sysConfig, mkNixGLPkg, ...}: let
    nixGlHyprland = mkNixGLPkg pkgs.hyprland pkgs.hyprland.meta.mainProgram;
in {
  wayland.windowManager.hyprland = let 
    mod = "ALT";
  in {
    enable = !sysConfig.headless;
    extraConfig = ''
    bind = , Print, exec, grimblast copy area

    bind = ${mod}, U, exec ${pkgs.lib.getExe (mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram)}

    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
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