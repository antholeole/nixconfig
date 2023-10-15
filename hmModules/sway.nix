{ pkgs, mkNixGLPkg, inputs, config, sysConfig, lib, ... }:
let
  modifier = "Mod1";
  launcherCommand = pkgs.lib.getExe
    (import "${inputs.self}/scripts/wofi_launch.nix" {
      inherit pkgs sysConfig config;
    });
  colors = import ../theme.nix;
  nixGlSway = mkNixGLPkg pkgs.sway;
  ewwExe = pkgs.lib.getExe config.programs.eww.package;
  ewwOnFocusedPath = pkgs.lib.getExe
    (import "${inputs.self}/scripts/eww_on_focused.nix" {
      inherit pkgs inputs;
    });
  ewwOnFocused = "${ewwOnFocusedPath} --eww ${ewwExe}";

  logSuffix = ">>/tmp/sway 2>&1";
in {
  wayland.windowManager.sway = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = nixGlSway;
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway # xdg-desktop-portal
      export XDG_SESSION_DESKTOP=sway # systemd
      export XDG_SESSION_TYPE=wayland # xdg/systemd
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
    '';
    systemd.enable = true;
    config = let powerbarMode = "powerbarMode";
    in {
      menu = launcherCommand;
      terminal = "exec ${pkgs.lib.getExe (mkNixGLPkg pkgs.alacritty)}";
      fonts = { names = [ "FiraCode Nerd Font" ]; };
      keybindings = lib.mkOptionDefault {
        "${modifier}+w" = "kill";
        "${modifier}+b" = "exec ${pkgs.polydoro}/bin/polydoro toggle";
        "${modifier}+space" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
        "${modifier}+Shift+4" = "exec ${pkgs.shutter-save}/bin/shutter-save";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+r" = "exec ${launcherCommand}";
        "${modifier}+shift+m" = "move workspace to output right";
        "${modifier}+m" = "focus output right";

        "${modifier}+q" =
          "exec ${ewwOnFocused} open powerbar; exec ${ewwOnFocused} open lightbox --all; mode ${powerbarMode}";

        # disable the default dmenu launcher
        "${modifier}+d" = null;
      };

      modes = {
        "${powerbarMode}" = let
          returnCmd =
            "exec ${ewwOnFocused} close lightbox --all; exec ${ewwOnFocused} close powerbar --all; mode default";

        in {
          "q" =
            "exec swaylock; ${returnCmd}"; # not nixpkgs swaylock so that we can run on non-nixos systems
          "r" = "exec reboot; ${returnCmd}";
          "l" = "exec swaymsg exit; ${returnCmd}";
          "s" = "exec poweroff; ${returnCmd}";
          "escape" = returnCmd;
        };
      };

      window = { titlebar = false; };

      startup =
        (builtins.map (cmd: { command = cmd; }) sysConfig.swayStartupCommands)
        ++ [
          #"${ewwExe} daemon"
        ];

      # bro got no bars
      bars = [ ];
    };

    extraConfig = ''
      input "1:1:AT_Translated_Set_2_keyboard" {
        xkb_layout us
        xkb_options caps:swapescape
      }
    '';
  };

  home.file."sway.desktop" = {
    enable = true;
    text = ''
      [Desktop Entry]
      Name=Sway
      Comment=An i3-compatible Wayland compositor
      Exec=${pkgs.lib.getExe nixGlSway}
      Type=Application
    '';
  };
}
