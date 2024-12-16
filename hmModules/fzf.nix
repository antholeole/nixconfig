{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # enabled in fish

    colors = let
      colors = config.colorScheme.palette;
      h = s: "#${s}";
    in {
      "bg+" = "${h colors.base01}";
      "bg" = "${h colors.base00}";
      "spinner" = "${h colors.base0C}";
      "hl" = "${h colors.base0D}";
      "fg" = "${h colors.base04}";
      "header" = "${h colors.base0D}";
      "info" = "${h colors.base0A}";
      "pointer" = "${h colors.base0C}";
      "marker" = "${h colors.base0C}";
      "fg+" = "${h colors.base06}";
      "prompt" = "${h colors.base0A}";
      "hl+" = "${h colors.base0D}";
    };

    defaultOptions = ["--height 20%"];
  };
}
