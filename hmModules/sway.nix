{ pkgs, inputs, sysConfig, lib, ... }: let 
  modifier = "Mod1";
  codeWorkspace = "";
  launcherCommand = "${pkgs.rofi}/bin/rofi -show run -run-command \"${pkgs.fish}/bin/fish -c '{cmd}'\"";
  swaySwitch = builtins.toFile "i3Switch" (builtins.readFile "${inputs.self}/scripts/sway_switch.py");
  colors = import ../theme.nix;
in  {
  wayland.windowManager.sway = lib.mkIf (!sysConfig.headless) {
    enable = true;

    config = {
      menu = launcherCommand;

      fonts = {
        names = [ "FiraCode Nerd Font" ];
      };
      
      keybindings = let 
        execSwaySwitch = "exec ${pkgs.python3}/bin/python3 ${swaySwitch}";
      in {
        "${modifier}+l" = "${execSwaySwitch} -d r";
        "${modifier}+h" = "${execSwaySwitch} -d l";

        "${modifier}+Shift+l" = "${execSwaySwitch} -d r --take";
        "${modifier}+Shift+h" = "${execSwaySwitch} -d l --take";

        "${modifier}+m" = "${execSwaySwitch} -s";
        "${modifier}+Shift+m" = "${execSwaySwitch} -s --take";

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
        { command = "${pkgs.feh}/bin/feh --bg-center ~/wall.png -B \\#1e2030"; }
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
