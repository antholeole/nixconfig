{ pkgs, inputs, ... }:
{
  programs.bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [ batman ];

    config = {
      theme = "Coldark-Dark";

      pager = "less -FR";
    };

  };

  home.shellAliases = {
    cat = "${pkgs.bat.outPath}/bin/bat --paging=never";
    man = "${pkgs.bat-extras.batman}/bin/batman";
    less = "${pkgs.bat.outPath}/bin/bat";
  };

  programs.bash.bashrcExtra = ''
  help() {
    "$@" --help 2>&1 | ${pkgs.bat.outPath}/bin/bat --plain --language=help
  }
  '';
}
