{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.micro = {
    enable = true;

    settings = {
      diff = true;
      autoclose = true;
      status = true;
      colorscheme = "catpuccin";
    };
  };

  programs.fish.shellAliases = {
    # strictly superior
    nano = "${lib.getExe pkgs.micro}";
  };

  # TODO this isnt working?
  # TODO zellij exit is the same as micro exit which obvoisouly does not wokr

  home.file.".config/micro/colorschemes/catpuccin.micro" = {
    text = ''
      color-link comment "#5B6078"

      color-link identifier "#8AADF4"
      color-link identifier.class "#8AADF4"
      color-link identifier.var "#8AADF4"

      color-link constant "#F5A97F"
      color-link constant.number "#F5A97F"
      color-link constant.string "#A6DA95"

      color-link symbol "#F5BDE6"
      color-link symbol.brackets "#F0C6C6"
      color-link symbol.tag "#8AADF4"

      color-link type "#8AADF4"
      color-link type.keyword "#EED49F"

      color-link special "#F5BDE6"
      color-link statement "#C6A0F6"
      color-link preproc "#F5BDE6"

      color-link underlined "#8AADF4"
      color-link error "bold #ED8796"
      color-link todo "bold #EED49F"

      color-link diff-added "#A6DA95"
      color-link diff-modified "#EED49F"
      color-link diff-deleted "#ED8796"

      color-link gutter-error "#ED8796"
      color-link gutter-warning "#EED49F"

      color-link statusline "#CAD3F5,#1E2030"
      color-link tabbar "#CAD3F5,#1E2030"
      color-link indent-char "#494D64"
      color-link line-number "#494D64"
      color-link current-line-number "#B7BDF8"

      color-link cursor-line "#363A4F,#CAD3F5"
      color-link color-column "#363A4F"
      color-link type.extended "default"
    '';
  };
}
