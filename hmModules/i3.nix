{ pkgs, inputs, sysConfig, lib, ... }: let 
  modifier = "Mod1";
  codeWorkspace = "";
  launcherCommand = "${pkgs.rofi}/bin/rofi -show run -run-command \"${pkgs.fish}/bin/fish -c '{cmd}'\"";
  i3Switch = builtins.toFile "i3Switch" (builtins.readFile "${inputs.self}/scripts/i3_switch.fish");
  colors = import ../theme.nix;
in  {
  xsession.windowManager.i3 = lib.mkIf (!sysConfig.headless) {
    enable = true;

    config = {
      menu = launcherCommand;

      fonts = {
        names = [ "FiraCode Nerd Font" ];
      };
      
      keybindings = {
        "${modifier}+l" = "exec ${pkgs.fish}/bin/fish ${i3Switch} right";
        "${modifier}+h" = "exec ${pkgs.fish}/bin/fish ${i3Switch} left";

        "${modifier}+Shift+l" = "exec ${pkgs.fish}/bin/fish ${i3Switch} right take";
        "${modifier}+Shift+h" = "exec ${pkgs.fish}/bin/fish ${i3Switch} left take";

        "${modifier}+r" = "exec ${launcherCommand}";

        "${modifier}+w" = "kill";

        "${modifier}+Shift+Tab" = "focus prev";
        "${modifier}+Tab" = "focus next";

        "${modifier}+q" = "exec i3lock";
        "${modifier}+b" = "exec ${pkgs.polydoro}/bin/polydoro toggle";
        "${modifier}+space" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
        "${modifier}+Shift+4" = "exec ${pkgs.shutter-save}/bin/shutter-save";
      };

      workspaceLayout = "stacking";

      window = {
        hideEdgeBorders = "both";
        titlebar = false;
      };

      startup = [
        { command = "i3-msg workspace ${codeWorkspace}"; }
        { command = "${pkgs.feh}/bin/feh --bg-center ~/wall.png -B \\#1e2030"; }
        { command = "systemctl --user restart polybar"; always = true; notification = false; }      
      ] ++ (if sysConfig.keymap != null then [
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
