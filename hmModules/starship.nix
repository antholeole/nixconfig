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
      right_format = "\${custom.jj} $git_metrics $directory$hostname ";

      directory = {format = "[  ┃ $path ](${bgFill})";};
      cmd_duration = {format = "${seperator}[$duration](${bgFill})";};
      shlvl = {disabled = true;};
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

      git_state = disabled;
      git_commit = disabled;

      # you can re-enable git_branch when not in a JJ repo but I find it rarely
      # helpful, so leave it disabled.
      git_branch = disabled;

      custom.jj = {
        ignore_timeout = true;
        description = "jj status";
        detect_folders = [".jj"];
        command = ''
${config.programs.jujutsu.package}/bin/jj log --revisions @ --no-graph --ignore-working-copy --color never --limit 1 --template '
separate(" ",
  if(bookmarks, bookmarks, if(empty, "(empty)", change_id.shortest(4))),
)
'
        '';
        format = "[ 󰜜 $output ](${fgFill})";
      };

      # always show git metrics, they're helpful even in JJ world.
      git_metrics = {
        only_nonzero_diffs = true;
        disabled = false;
        format = "[ +$added ](${bgFill})${seperator}[ -$deleted ](${bgFill})";
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
