{ pkgs, inputs, sysConfig, lib, ... }: let 
  modifier = "Mod1";
  codeWorkspace = "";
  launcherCommand = "${pkgs.rofi}/bin/rofi -show run -run-command \"${pkgs.fish}/bin/fish -c '{cmd}'\"";
  colors = import ../theme.nix;
in  {
  wayland.windowManager.sway = lib.mkIf (!sysConfig.headless) {
    enable = true;

    # todo: this is not working. command "sss" will enable this for now.
    extraSessionCommands = ''      
      export XDG_CURRENT_DESKTOP=sway # xdg-desktop-portal
      export XDG_SESSION_DESKTOP=sway # systemd
      export XDG_SESSION_TYPE=wayland # xdg/systemd

      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
    '';

    systemd.enable = true;

    config = {
      menu = launcherCommand;

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
      };

      window = {
        titlebar = false;
      };

      startup = (if sysConfig.keymap != null then [
        { command = "setxkbmap -option ${sysConfig.keymap}"; }
      ] else []);
      
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
}
