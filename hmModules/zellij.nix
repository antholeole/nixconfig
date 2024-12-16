{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  layoutDir = ".config/zellij/layouts";

  bgColor = "#${config.colorScheme.palette.base01}";
  fgColor = "#${config.conf.termColor}";

  defaultTab = ''
    default_tab_template {
      children
      ${config.zjstatus}
      }
  '';
in {
  options.zjstatus = lib.options.mkOption {
    type = lib.types.string;
    default = let
      bgColor = config.colorScheme.palette.base00;
    in ''
      pane size=1 borderless=true {
             plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
               format_space "#[bg=${bgColor}]"

               mode_normal  "#[bg=${fgColor},fg=${config.colorScheme.palette.base05}] {name} "
               mode_locked  "#[bg=${config.colorScheme.palette.base0B},fg=${bgColor}] {name} "

               tab_normal   "#[fg=${fgColor}] {name} "
               tab_active   "#[fg=${bgColor},bg=${fgColor}] {name} "

               format_left  "{tabs}"
               format_right "#[fg=${fgColor},bg=${bgColor}] {session} {mode} "
             }
           }
    '';
  };

  config = {
    home.packages = [pkgs.zellij];
    home.file.".config/zellij/config.kdl".text = ''
      default_layout "default"
      default_shell "${config.programs.fish.package}/bin/fish"
      keybinds {
      	unbind "Ctrl Q"
        scroll {
          bind "Ctrl u" { HalfPageScrollUp; }
          bind "Ctrl d" { HalfPageScrollDown; }
        }
      }
      mouse_mode false
      pane_frames false
      scrollback_editor "${config.programs.kakoune.package}/bin/kak"
      theme "gruvbox-dark"
      ui {
      	pane_frames {
      		hide_session_name true
      	}
      }
    '';

    home.file."${layoutDir}/default.kdl" = {
      enable = true;
      text = ''
        layout {
          ${defaultTab}
        }
      '';
    };

    home.file."${layoutDir}/zedit.kdl" = {
      enable = true;
      text = ''
         	layout {
           tab {
           pane {
               command "${pkgs.kakoune}/bin/kak"
               args "."
             }


         	floating_panes {
         		pane {
               command "${pkgs.zellij}/bin/zellij"
               args "--layout" "default"

         			width "90%"
         			height "90%"
         			x "5%"
         			y "5%"
         		}
         	}
            }
        }
         keybinds clear-defaults=true {
         	shared {
         		bind "F11" { ToggleFloatingPanes; }
             bind "Ctrl q" { Quit; }
         	}
         }

         default_shell "fish"
         default_layout "compact"

      '';
    };
  };
}
