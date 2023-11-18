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
      mkMode = { 
        name, 
        widget, 
        cmds ? { }, 
        closingCmds ? { }, 
        enterKey,
        isVisibleVar ? null
      }: {
        enter = {
          "${modifier}+${enterKey}" =
            "exec ${ewwOnFocused} open ${widget}; exec ${ewwOnFocused} open lightbox --all; mode ${name}" + (if isVisibleVar != null then "; ${ewwExe} update ${isVisibleVar}IsVisible=true" else "");
        };

        mode."${name}" = let
          closeCmd =
            "exec ${ewwOnFocused} close lightbox --all; exec ${ewwOnFocused} close ${widget} --all; mode default" + (if isVisibleVar != null then "; ${ewwExe} update ${isVisibleVar}IsVisible=false" else "");

          closingKeybinds = (lib.attrsets.concatMapAttrs (keybind: closingCmd: {
            "${keybind}" = "${closingCmd}; ${closeCmd}";
          }) closingCmds);

          keybinds = lib.attrsets.concatMapAttrs
            (keybind: cmd: { "${keybind}" = "${cmd}"; }) cmds;

          stdKeybinds = { "escape" = "${closeCmd}; mode default"; };
        in (closingKeybinds // keybinds // stdKeybinds);
      };

      modes = let
        ewwScriptsDir = "~/.config/eww/scripts/";
        execEwwScript = script: args: "exec ${pkgs.lib.getExe pkgs.python3} ${ewwScriptsDir}${script}.py --eww ${ewwExe} ${args}";
      in [
        (mkMode {
          name = "powerbar";
          widget = "powerbar";
          enterKey = "q";
          isVisibleVar = "volumeControl";

          cmds = {
            "r" = "exec reboot";
            "l" = "exec swaymsg exit";
            "s" = "exec sudo poweroff";
          };

          closingCmds = {
            # global swaylock so that we can run on non-nixos systems
            "q" = "exec swaylock";
          };
        })
        (mkMode {
          name = "volctrl";
          widget = "volume-ctrl";
          enterKey = "space";

          cmds = { 
            "space" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";

            "l" = execEwwScript "vol" "vol_inc --amount 1";
            "shift+l" = execEwwScript "vol" "vol_inc --amount 5";

            "h" = execEwwScript "vol" "vol_dec --amount 1";
            "shift+h" = execEwwScript "vol" "vol_dec --amount 5";

            "j" = execEwwScript "vol" "idx_inc";
            "k" = execEwwScript "vol" "idx_dec";
          };
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
