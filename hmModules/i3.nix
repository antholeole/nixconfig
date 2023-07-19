{ pkgs, inputs, ... }: let 
  modifier = "Mod1";
  codeWorkspace = "";
  browserWorkspace = " ";
  miscWorkspace = "";
  launcherCommand = "${pkgs.rofi}/bin/rofi -show run";
  i3Switch = builtins.toFile "i3Switch" (builtins.readFile "${inputs.self}/scripts/i3_switch.fish");
in  {
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      menu = launcherCommand;

      fonts = {
        names = [ "FiraCode Nerd Font" ];
        size = 12.0;
      }
      
      keybindings = {
        "${modifier}+l" = "exec ${pkgs.fish}/bin/fish ${i3Switch} right";
        "${modifier}+h" = "exec ${pkgs.fish}/bin/fish ${i3Switch} left";

        "${modifier}+r" = "exec ${launcherCommand}";

        "${modifier}+w" = "kill";

        "${modifier}+Shift+Tab" = "focus prev";
        "${modifier}+Tab" = "focus next";

        "${modifier}+q" = "exec i3lock";
      };

      workspaceLayout = "stacking";


      startup = [
        { command = "i3-msg workspace ${codeWorkspace}"; }
        { command = "systemctl --user restart polybar"; always = true; notification = false; }      
      ];
    };
  };
}
