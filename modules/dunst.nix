let
  colors = import ../theme.nix;
in
{
  enable = true;


  settings = {
    global = {
      frame_color = colors.flamingo;
      frame_width = 1;
      seperator_color = "frame";
      
      font = "FiraCode Nerd Font 10";
    };

    urgency_low = {
      background = colors.base;
      foreground = colors.text;
    };

    urgency_normal = {
      background = colors.base;
      foreground = colors.text;
    };

    urgency_critical = {
      background = colors.base;
      foreground = colors.text;

      frame_color = colors.red;
    };
  };
}
  
