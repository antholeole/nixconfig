{
  pkgs,
  inputs,
  ...
}: {
  programs.bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [batman];

    themes = {
      catppuccin-macchiato = {
        src = "${inputs.catppuccin-bat}/themes";
        file = "Catppuccin Macchiato.tmTheme";
      };
    };

    config = {
      theme = "catppuccin-macchiato";
      pager = "less -FR";
    };
  };

  programs.fish.shellAliases = {
    cat = "${pkgs.bat.outPath}/bin/bat --paging=never";
    man = "${pkgs.bat-extras.batman}/bin/batman";
    less = "${pkgs.bat.outPath}/bin/bat";
  };

  programs.fish.functions.help = ''
    "$argv" --help 2>&1 | ${pkgs.bat.outPath}/bin/bat --plain --language=help
  '';
}
