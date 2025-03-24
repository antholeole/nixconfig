{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  gruvbox-dark-medium = "gruvbox-dark-medium";
in {
  programs.k9s = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "k9s";
      paths = [pkgs-unstable.k9s];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/k9s \
          --set KUBECACHEDIR ${config.conf.homeDirPath}${config.conf.name}/.kube/cache \
          --set K9S_FEATURE_GATE_NODE_SHELL true
      '';
    };

    settings.k9s = {
      ui = {
        headless = true;
        logoless = true;
      };

      featureGates = {
        nodeShell = true;
      };

      skipLatestRevCheck = true;
    };

    skins."${gruvbox-dark-medium}".k9s = with config.colorScheme.palette; let
      background = "default";

      mkColor = color: "#${color}";

      foreground = mkColor base07;
      # everything else is gruvbox-dark default from k9s itself.
      current_line = mkColor base06;
      selection = mkColor base05;
      comment = mkColor base04;
      cyan = mkColor base0C;
      green = mkColor base0B;
      orange = mkColor base09;
      magenta = mkColor base0E;
      blue = mkColor base0D;
      red = mkColor base08;
    in {
      body = {
        fgColor = foreground;
        bgColor = background;
        logoColor = blue;
      };
      prompt = {
        fgColor = foreground;
        bgColor = background;
        suggestColor = orange;
      };
      info = {
        fgColor = magenta;
        sectionColor = foreground;
      };
      help = {
        fgColor = foreground;
        bgColor = background;
        keyColor = magenta;
        numKeyColor = blue;
        sectionColor = green;
      };
      dialog = {
        fgColor = foreground;
        bgColor = background;
        buttonFgColor = foreground;
        buttonBgColor = magenta;
        buttonFocusFgColor = "white";
        buttonFocusBgColor = cyan;
        labelFgColor = orange;
        fieldFgColor = foreground;
      };
      frame = {
        border = {
          fgColor = selection;
          focusColor = current_line;
        };
        menu = {
          fgColor = foreground;
          keyColor = magenta;
          numKeyColor = magenta;
        };
        crumbs = {
          fgColor = foreground;
          bgColor = comment;
          activeColor = blue;
        };
        status = {
          newColor = cyan;
          modifyColor = blue;
          addColor = green;
          errorColor = red;
          highlightColor = orange;
          killColor = comment;
          completedColor = comment;
        };
        title = {
          fgColor = foreground;
          bgColor = background;
          highlightColor = orange;
          counterColor = blue;
          filterColor = magenta;
        };
      };
      views = {
        charts = {
          bgColor = background;
          defaultDialColors = [blue red];
          defaultChartColors = [blue red];
        };
        table = {
          fgColor = foreground;
          bgColor = background;
          cursorFgColor = "#fff";
          cursorBgColor = current_line;
          header = {
            fgColor = foreground;
            bgColor = background;
            sorterColor = selection;
          };
        };
        xray = {
          fgColor = foreground;
          bgColor = background;
          cursorColor = current_line;
          graphicColor = blue;
          showIcons = false;
        };
        yaml = {
          keyColor = magenta;
          colonColor = blue;
          valueColor = foreground;
        };
        logs = {
          fgColor = foreground;
          bgColor = background;
          indicator = {
            fgColor = foreground;
            bgColor = background;
          };
        };
      };
    };
  };
}
