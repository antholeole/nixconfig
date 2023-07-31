{ pkgs, inputs, ... }:
{
  programs.kakoune = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.kakoune}/bin/kak";
  };
}
