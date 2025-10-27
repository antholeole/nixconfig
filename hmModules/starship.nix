{config, ...}: {
  programs.starship = let
    disabled = {disabled = true;};

    seperator = "[┃]($style)";

  in {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "$directory$hostname$line_break$character";

      # trailing space so it lines up with zellij
      right_format = "$cmd_duration\${custom.jj}$git_metrics";

      # directory = {format = "[  ┃ $path ]($style)";};
      # cmd_duration = {format = "${seperator}[$duration]($style)";};
      shlvl = {disabled = true;};
      battery.disabled = true;

      hostname = {
        ssh_symbol = "󱘖 ";
        disabled = false;
        format = "[$ssh_symbol ]($style)";
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
        format = "[ 󰜜 $output ]($style)";
      };

      # always show git metrics, they're helpful even in JJ world.
      git_metrics = {
        only_nonzero_diffs = true;
        disabled = false;
        format = "[ +$added ]($style)[ -$deleted ]($style)";
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
