{ pkgs, mkNixGLPkg, inputs, sysConfig, lib, ... }:
let
  modifier = "Mod1";
  codeWorkspace = "";
  launcherCommand = "${lib.getExe pkgs.fish} -c history | ${lib.getExe pkgs.wofi} --show dmenu | ${lib.getExe pkgs.fish}";
  colors = import ../theme.nix;

  nixGlSway = mkNixGLPkg pkgs.sway;
in
{
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

    config = {
      menu = launcherCommand;
      terminal = "exec ${pkgs.lib.getExe (mkNixGLPkg pkgs.alacritty)}";

      fonts = {
        names = [ "FiraCode Nerd Font" ];
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+w" = "kill";

        "${modifier}+q" = "exec swaylock"; # not nixpkgs swaylock so that we can run on non-nixos systems
        "${modifier}+b" = "exec ${pkgs.polydoro}/bin/polydoro toggle";
        "${modifier}+space" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
        "${modifier}+Shift+4" = "exec ${pkgs.shutter-save}/bin/shutter-save";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+d" = null;
        "${modifier}+r" = "exec ${launcherCommand}";
      };

      window = {
        titlebar = false;
      };

      startup = (if sysConfig.keymap != null then [
        { command = "setxkbmap -option ${sysConfig.keymap}"; }
        { command = "swaybar --bar_id bar-0"; }
      ] else [ ]);

      bars = [{
        fonts = {
          names = [ "FiraCode Nerd Font" ];
          size = sysConfig.fontSizes.glFontSize + 0.0; # hack to get int to float
        };

        colors = with colors; {
          background = crust;
          focusedWorkspace = {
            background = flamingo;
            border = flamingo;
            text = crust;
          };
        };

        position = "bottom";
      }];
    };
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
