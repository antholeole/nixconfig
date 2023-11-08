{ config, inputs, pkgs, sysConfig, ... }:
let
  colors = import ../theme.nix;
  layoutDir = ".config/zellij/layouts";
in {
  programs.zellij = {
    enable = true;

    enableFishIntegration = true;

    settings = {
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
    };

    settings = {
      default_shell = "${pkgs.lib.getExe config.programs.fish.package}";
    };
  };

  home.file."${layoutDir}/default.kdl" = {
    enable = true;
    text = ''
      layout {
        default_tab_template {
          children
          pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
            }
          }
      }
    '';
  };

  home.file."${layoutDir}/standard.kdl" = let
    daily = import "${inputs.self}/scripts/daily_sh.nix" pkgs sysConfig;
    notes = import "${inputs.self}/scripts/notes.nix" { inherit pkgs inputs; };
  in {
    enable = true;
    text = ''
      layout {
      default_tab_template {
        children
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
          }
        }
        tab name="btm" {
          pane command="${pkgs.lib.getExe pkgs.bottom}"
        }
        tab name="daily" split_direction="vertical" {
          pane split_direction="horizontal" {
            pane command="${pkgs.lib.getExe daily}"
            pane command="${pkgs.lib.getExe' pkgs.pipes-rs "pipes-rs"}" {
              args "--rainbow" "5" "-c" "rgb" "-p" "1" "-r" "0.75"
            } 
          }
          pane command="${pkgs.lib.getExe notes}"
        }
        tab name="misc"
      }
    '';
  };
}
