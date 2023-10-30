{ pkgs, mkNixGLPkg, inputs, config, sysConfig, lib, ... }:
let
  modifier = "Mod1";
  launcherCommand = pkgs.lib.getExe
    (import "${inputs.self}/scripts/wofi_launch.nix" {
      inherit pkgs sysConfig config;
    });
  colors = import ../theme.nix;
  nixGlSway = mkNixGLPkg pkgs.sway pkgs.sway.meta.mainProgram;
  ewwExe = pkgs.lib.getExe config.programs.eww.package;
  ewwOnFocusedPath = pkgs.lib.getExe
    (import "${inputs.self}/scripts/eww_on_focused.nix" {
      inherit pkgs inputs;
    });
  ewwOnFocused = "${ewwOnFocusedPath} --eww ${ewwExe}";

  # useful for when stuff isn't working
  logSuffix = ">>/tmp/sway 2>&1";
in {
  wayland.windowManager.sway = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = nixGlSway;
    systemd.enable = true;
    config = let
      mkMode = { name, exitCmd, cmds, enterKey, enterCmd }: {
        enter = { "${modifier}+${enterKey}" = "${enterCmd}; mode ${name}"; };

        mode."${name}" = (lib.attrsets.concatMapAttrs
          (keybind: cmd: { "${keybind}" = "${cmd}; ${exitCmd}"; }) cmds);
      };

      modes = [
        (mkMode {
          name = "powerbar";
          exitCmd =
            "exec ${ewwOnFocused} close lightbox --all; exec ${ewwOnFocused} close powerbar --all";
          enterKey = "q";
          enterCmd =
            "exec ${ewwOnFocused} open powerbar; exec ${ewwOnFocused} open lightbox --all";

          cmds = {
            # global swaylock so that we can run on non-nixos systems
            "q" = "exec swaylock";

            # TODO these don't work
            "r" = "exec reboot";
            "l" = "exec swaymsg exit";
            "s" = "exec sudo poweroff";
          };
        })
        (mkMode {
          name = "volctrl";
          exitCmd =
            "exec ${ewwOnFocused} close lightbox --all; exec ${ewwOnFocused} close powerbar --all";
        })
      ];
    in {
      menu = launcherCommand;
      terminal = "exec ${
          pkgs.lib.getExe
          (mkNixGLPkg pkgs.alacritty pkgs.alacritty.meta.mainProgram)
        }";
      fonts = { names = [ "FiraCode Nerd Font" ]; };
      keybindings = with lib;
        mkOptionDefault
        ((attrsets.mergeAttrsList (builtins.map (mode: mode.enter) modes)) // {
          "${modifier}+w" = "kill";
          "${modifier}+space" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+r" = "exec ${launcherCommand}";
          "${modifier}+shift+m" = "move workspace to output right";
          "${modifier}+m" = "focus output right";

          # disable the default dmenu launcher
          "${modifier}+d" = null;
        });

      modes = with builtins;
        lib.attrsets.mergeAttrsList (map (mode: mode.mode) modes);

      window = { titlebar = false; };

      startup = (builtins.map (cmd: { command = cmd; })
        (sysConfig.swayStartupCommands ++ [ "${ewwExe} daemon" ]));

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
