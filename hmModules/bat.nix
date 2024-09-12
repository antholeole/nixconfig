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
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };

        file = "Catppuccin-macchiato.tmTheme";
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
