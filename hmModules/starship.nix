let
  bracket_langs = [
    "python"
    "java"
    "package"
    "nodejs"
    "golang"
    "rust"
    "julia"
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
  programs.starship = {
    enable = true;
  enableBashIntegration = true;

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

    git_branch = {
      format = "[\\[$symbol$branch\\]]($style)";
    };

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

    time = {
      disabled = false;
      style = "bold bright-black";
      format = "[$time]($style)";
    };

    # this is because VSCode already notifies success || failure.
    character = {
      format = " ";
    };
  };
};
}