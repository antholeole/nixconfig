{ config, pkgs, lib, sysConfig, ... }:
let
  colors = import ../theme.nix;
in
{
  programs.rofi = lib.mkIf (!sysConfig.headless) {
    enable = true;
    terminal = "${pkgs.alacritty.outPath}/bin/alacritty";

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          "font" =
            "FiraCode Nerd Font ${toString sysConfig.fontSizes.defaultFontSize}";
          "background-color" = mkLiteral "transparent";
          "text-color" = mkLiteral "${colors.text}";
        };

        "window" = {
          "background-color" = mkLiteral "${colors.base}";
          "border-color" = mkLiteral "${colors.flamingo}";

          "location" = mkLiteral "center";
          "width" = mkLiteral "40%";
          "border" = mkLiteral "1px";
        };

        "inputbar" = {
          "padding" = mkLiteral "8px 12px";
          "spacing" = mkLiteral "12px";
          "children" = mkLiteral "[ prompt, entry ]";
        };

        "prompt" = {
          "text-color" = mkLiteral "${colors.flamingo}";
        };

        "prompt, entry, element-text, element-icon" = {
          "vertical-align" = mkLiteral "0.5";
        };

        "listview" = {
          "lines" = mkLiteral "12";
          "columns" = mkLiteral "1";

          "fixed-height" = mkLiteral "true";
        };

        "element.normal" = {
          "margin" = mkLiteral "0px 6px";
        };


        "element.selected" = {
          "background-color" = mkLiteral "${colors.flamingo}";
        };

        "element-text.selected" = {
          "text-color" = mkLiteral "${colors.mantle}";
        };

        "element-icon" = {
          "size" = mkLiteral "0.75em";
        };
      };
  };
}
