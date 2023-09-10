{ inputs, pkgs, sysConfig, ... }:
let
  colors = import ../theme.nix;
  layoutDir = ".config/zellij/layouts";
in
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      theme = "catpuccin";

      scrollback_editor = "${pkgs.kakoune}/bin/kak";

      pane_frames = false;
      mouse_mode = false;
      default_layout = "compact";

      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };

      keybinds = {
        unbind = {
          _repeatedKey = [ "Alt h" "Alt l" "Ctrl b" ];
        };

        normal = {
          bind = {
            _repeatedKey = [{
              _args = [ "Ctrl h" ];
              MoveFocusOrTab = "Left";
            }
              {
                _args = [ "Ctrl l" ];
                MoveFocusOrTab = "Right";
              }
              {
                _args = [ "Ctrl j" ];
                MoveFocusOrTab = "Down";
              }
              {
                _args = [ "Ctrl k" ];
                MoveFocusOrTab = "Up";
              }];
          };
        };
      };

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
    };
  };

  home.file."${layoutDir}/custom-default.kdl" = {
    enable = true;
    text = ''
      layout {
        pane size = 1 borderless=true {
          plugin location="zellij:tab-bar"
        }
        pane
      }
    '';
  };

  home.file."${layoutDir}/standard.kdl" =
    let
      daily = import "${inputs.self}/scripts/daily_sh.nix" pkgs sysConfig;
    in
    {
      enable = true;
      text = ''
        layout {
          tab name="btm" {
            pane command="btm"
          }
          tab name="daily" {
            pane command="${pkgs.lib.getExe daily}"
          }
          tab name="misc"
          pane size = 1 borderless=true {
            plugin location="zellij:tab-bar"
          }
        }
      '';
    };
}
