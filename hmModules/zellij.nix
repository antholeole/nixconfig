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

      default_layout = "~/${layoutDir}/custom_2_tab.kdl";
      
      ui = {
        pane_frames = {
          hide_session_name = true;
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
