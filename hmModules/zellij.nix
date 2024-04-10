{ config, pkgs, sysConfig, ... }:
let
  colors = import ../theme.nix;
  layoutDir = ".config/zellij/layouts";

  bgColor = colors.mantle;
  fgColor = sysConfig.termColor;

  zjStatus = ''
    pane size=1 borderless=true {
           plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
             format_space "#[bg=${bgColor}]"

             mode_normal  "#[bg=${fgColor},fg=${colors.base}] {name} "
             mode_locked  "#[bg=${colors.yellow},fg=${bgColor}] {name} "

             tab_normal   "#[fg=${fgColor}] {name} "
             tab_active   "#[fg=${bgColor},bg=${fgColor}] {name} "

             format_left  "{tabs}"
             format_right "#[fg=${fgColor},bg=${bgColor}] {session} {mode} "
           }
         }
  '';

  defaultTab = ''
    default_tab_template {
      children
      ${zjStatus}
      }
  '';
in {
  programs.zellij = {
    enable = true;

    # enabling this would autostart a zellij session every time we activate
    # fish. We can do that manually, with more configuration.
    enableFishIntegration = false;

    settings = {
      # allows ctrl Q to just exit zedit. We live inside zellij anyway
      keybinds.unbind = "Ctrl Q";

      theme = "catpuccin";

      scrollback_editor = "${pkgs.kakoune}/bin/kak";

      pane_frames = false;
      mouse_mode = false;
      default_layout = "compact";

      ui = { pane_frames = { hide_session_name = true; }; };

      themes = {
        catpuccin = with colors; {
          inherit red green blue yellow;

          bg = surface2;
          fg = text;

          magenta = pink;
          orange = peach;
          cyan = sky;
          black = mantle;
          white = text;
        };
      };

      default_shell = "${pkgs.lib.getExe config.programs.fish.package}";
    };
  };

  home.file."${layoutDir}/default.kdl" = {
    enable = true;
    text = ''
      layout {
        ${defaultTab}
      }
    '';
  };

  # "command tab"
  home.file."${layoutDir}/templates/ct.kdl" = {
    enable = true;
    text = ''
      layout {
        pane_template name="cmd" {
          command "COMMAND"
          args "ARGS"
        }

        tab name="COMMAND" {
      	pane stacked=true {
          REPEAT_ME
      	}
        
        ${zjStatus}
        }
      }
    '';
  };

  home.file."${layoutDir}/zedit.kdl" = {
    enable = true;
    text = ''
       	layout {
         tab {
         pane {
             command "${pkgs.helix}/bin/hx"
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
}
