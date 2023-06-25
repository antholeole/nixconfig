{ inputs, ... }: let
  colors = import ../theme.nix;
  layoutDir = ".config/zellij/layouts";
 in  {
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      theme = "catpuccin";

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
          _repeatedKey = ["Alt h" "Alt l" "Ctrl b"];
        };

        normal = {
          bind = {
           _repeatedKey = [{
              _args = ["Ctrl h"];
              MoveFocusOrTab = "Left";
           } {
              _args = ["Ctrl l"];
              MoveFocusOrTab = "Right";
           } {
              _args = ["Ctrl j"];
              MoveFocusOrTab = "Down";
           } {
              _args = ["Ctrl k"];
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

  home.file."${layoutDir}" = {
    recursive = true;
    source = "${inputs.self}/confs/zellij/layouts";
  };
}
