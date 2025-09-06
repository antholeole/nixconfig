{pkgs, ...}: {
  programs.bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [batman];

    config = {
      theme = "gruvbox-dark";
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
