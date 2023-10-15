{ ... }: {
  programs.starship = let
    vc = {
      format = "[\\[$symbol$branch\\]]($style)";
      disabled = false;
    };

    mkLangFmt = lang: {
      disabled = false;
      format = "[\\[$symbol($version)\\]]($style)";
    };

    mkSymbol = symbol: { inherit symbol; };
  in {
    enable = true;
    enableFishIntegration = true;

    settings = {
      python = mkLangFmt "python";
      java = mkLangFmt "java";
      package = mkLangFmt "package";
      nodejs = mkLangFmt "nodejs";
      golang = mkLangFmt "golang";
      rust = mkLangFmt "rust";
      julia = mkLangFmt "julia";
      dart = mkLangFmt "dart";
      cmake = mkLangFmt "cmake";
      scala = mkLangFmt "scala" // mkSymbol "";
      terraform = mkLangFmt "terraform" // mkSymbol " ";

      gcloud.disabled = true;

      directory = { format = "[\\[$path$read_only\\]]($style)"; };

      username = { format = "[\\[$user\\]]($style)"; };

      cmd_duration = { format = "[\\[$duration\\]]($style)"; };

      shlvl = { disabled = true; };

      git_branch = vc;
      hg_branch = vc;

      git_status = { disabled = true; };

      line_break = { disabled = true; };

      right_format = "$time";

      nix_shell = {
        symbol = "󱄅 ";
        format = "[\\[$symbol($name)\\]]($style)";
      };

      battery.disabled = true;

      hostname = {
        ssh_symbol = "󱘖 ";
        style = "green";
        format = "[\\[$ssh_symbol($hostname)\\]]($style)";
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
    };
  };
}
