{config, ...}: {
  programs.starship = let
    disabled = {disabled = true;};

    h = s: "#${s}";

    color = config.conf.termColor;

    bgFill = "bg:${h color} fg:${h config.colorScheme.palette.base03}";
    fgFill = "fg:${h color}";

    seperator = "[┃](${bgFill})";

    vc = {
      format = "[$symbol](${fgFill})[$branch](${fgFill})";
      disabled = false;
    };
  in {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "$character";

      # trailing space so it lines up with zellij
      right_format = "$git_branch $git_metrics $directory$hostname ";

      directory = {format = "[  ┃ $path ](${bgFill})";};
      cmd_duration = {format = "${seperator}[$duration](${bgFill})";};
      shlvl = {disabled = true;};
      git_branch = vc;
      git_metrics = {
        only_nonzero_diffs = true;
        disabled = false;
        format = "[ +$added ](${bgFill})${seperator}[ -$deleted ](${bgFill})";
      };
      hg_branch = vc;
      battery.disabled = true;

      hostname = {
        ssh_symbol = "󱘖 ";
        disabled = false;
        format = "[$ssh_symbol ](${bgFill})";
      };

      character = {
        success_symbol = "[󰘧](${fgFill})";
        error_symbol = "[󰘧](red)";
        format = "$symbol($style) ";
      };

      time = disabled;
      gcloud = disabled;
      line_break = disabled;
      python = disabled;
      java = disabled;
      package = disabled;
      nodejs = disabled;
      golang = disabled;
      rust = disabled;
      julia = disabled;
      dart = disabled;
      cmake = disabled;
      scala = disabled;
      terraform = disabled;
    };
  };
}
