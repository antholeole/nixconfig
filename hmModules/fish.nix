{ inputs, pkgs, ... }:
let
  xclipPath = "${pkgs.xclip.outPath}/bin/xclip";
in
{
  programs.fish = {
    enable = true;

    shellAliases = {
      c = "${xclipPath} -selection clipboard";
      v = "${xclipPath} -o -selection clipboard";
    };

    functions = {
      cdc = "mkdir -p $argv && cd $argv";
    };

    plugins = [
      {
        name = "bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "7d93e8a57b881102bc8beee64b75922f58de4700";
          sha256 = "NAXaINBvjuRY2343OD4GkHZAZqcTJvE4RHgdi8xj028=";
        };
      }
    ];

    interactiveShellInit = ''
      set fish_greeting
      ${pkgs.neofetch.outPath}/bin/neofetch
    '';
  };
  # on systems where we cannot configure the default shell, it helps to write
  # a bashrc to start fish, so we can use it anyway
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      fish; 
    '';
  };
}
