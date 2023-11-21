{ ... }: {
  programs.starship = let
    disabled = {
      disabled = true;
    };

    style = "bold ${(import ../theme.nix).lavender}";

    vc = {
      format = "[\\[$symbol$branch\\]](${style})";
      disabled = false;
    };
  in {
    enable = true;
    enableFishIntegration = true;

    settings = {
      gcloud.disabled = true;
      directory = { format = "[\\[$path$read_only\\]](${style})"; };
      username = { format = "[\\[$user\\]](${style})"; };
      cmd_duration = { format = "[\\[$duration\\]]($style)"; };
      shlvl = { disabled = true; };
      git_branch = vc;
      hg_branch = vc;
      git_status = { disabled = true; };
      line_break = { disabled = true; };
      right_format = "$time";
      battery.disabled = true;

      hostname = {
        ssh_symbol = "󱘖 ";
        format = "[\\[$ssh_symbol\\]](${style})";
      };

      time = {
        disabled = false;
        style = "bold bright-black";
        format = "[$time]($style)";
      };

      character = {
        success_symbol = "";
        error_symbol = "[\\[!\\]](bold red)";
        format = "$symbol($style) ";
      };

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
