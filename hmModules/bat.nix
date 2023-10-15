{ pkgs, inputs, ... }: {
  programs.bat = let theme = "Catpuccin Machiatto";
  in {
    enable = true;

    extraPackages = with pkgs.bat-extras; [ batman ];

    themes."${theme}" = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "sublime-text";
        rev = "f748732eb9752aa3d161a016e50cca296009c66b";
        sha256 = "sha256-GehfCttJBAiV7k52D2TfUMeoK7hGextlnINaCwmQFi8=";
      };
      file = "${theme}.sublime-color-scheme";
    };

    config = {
      inherit theme;

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
