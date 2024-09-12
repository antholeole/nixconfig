{
  config,
  pkgs,
  sysConfig,
  inputs,
  ...
}: let
  colors = import ../theme.nix;
  layoutDir = ".config/zellij/layouts";

  bgColor = colors.mantle;
  fgColor = sysConfig.termColor;

  zjStatus = (import "${inputs.self}/shared/zjstatus.nix") pkgs sysConfig;

  defaultTab = ''
    default_tab_template {
      children
      ${zjStatus}
      }
  '';
in {
  home.packages = [pkgs.zellij];
  home.file.".config/zellij/config.kdl".text = with colors; ''
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
    theme "catpuccin"
    themes {
    	catpuccin {
    		bg "${surface2}"
    		black "${mantle}"
    		blue "${blue}"
    		cyan "${sky}"
    		fg "${text}"
    		green "${overlay0}"
    		magenta "${pink}"
    		orange "${peach}"
    		red "${red}"
    		white "${text}"
    		yellow "${yellow}"
    	}
    }
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
}
