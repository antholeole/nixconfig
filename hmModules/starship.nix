let
  bracket_langs = [
    "python"
    "java"
    "package"
    "nodejs"
    "golang"
    "rust"
    "julia"
    "scala"
    "dart"
    "terraform"
  ];
  lang_to_attr = root: {
    name = root;
    value = {
      disabled = false;
      format = "[\\[$symbol($version)\\]]($style)";
    };
  };
in
{
  programs.starship =
    let
      vc = {
        format = "[\\[$symbol$branch\\]]($style)";
        disabled = false;
      };
    in
    {
      enable = true;
      enableFishIntegration = true;

      settings = builtins.listToAttrs (map lang_to_attr bracket_langs) // {
        directory = {
          format = "[\\[$path$read_only\\]]($style)";
        };

        username = {
          format = "[\\[$user\\]]($style)";
        };

        cmd_duration = {
          format = "[\\[$duration\\]]($style)";
        };

        shlvl = {
          disabled = true;
        };

        git_branch = vc;
        hg_branch = vc;

        git_status = {
          disabled = true;
        };

        line_break = {
          disabled = true;
        };

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
