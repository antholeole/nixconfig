{ pkgs, ...}: {
  home-manager.users.anthony.programs.starship = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            directory = {
              format = "[\\[$path$read_only\\]]($style)";
            };

            username = {
              format = "[\\[$user\\]]($style)";
              show_always = true;
            };

            shlvl = {
              disabled = false;
              symbol = ">";
              repeat = true;
              threshold = 2;
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

            time = {
              disabled = false;
              style = "bold bright-black";
              format = "[$time]($style)";
            };

            # this is because VSCode already
            # notifies success || failure
            character = {
              format = " ";
            };
          };
    };
}