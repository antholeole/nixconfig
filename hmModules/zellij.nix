{ config, pkgs, sysConfig, inputs, ... }:
let
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
      default_layout = "default";

      ui = { pane_frames = { hide_session_name = true; }; };

      themes = {
        catpuccin = with colors; {
          inherit red blue yellow;

          # green is used for the borders
          green = overlay0;
          orange = peach;

          bg = surface2;
          fg = text;

          magenta = pink;
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
