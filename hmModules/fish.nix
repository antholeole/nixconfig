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
  programs.bash = let 
    fish = "${pkgs.fish}/bin/fish";
   in {
    enable = true;
    bashrcExtra = ''
    if [[ "$-" =~ i && -x "${fish}" && ! "\$\{SHELL}" -ef "${fish}" && -z "''${IN_NIX_SHELL}" ]]; then
      # Safeguard to only activate fish for interactive shells and only if fish
      # shell is present and executable. Verify that this is a new session by
      # checking if $SHELL is set to the path to fish. If it is not, we set
      # $SHELL and start fish.
      #
      # If this is not a new session, the user probably typed 'bash' into their
      # console and wants bash, so we skip this.
      exec env SHELL="${fish}" "${fish}" -i
    fi    
    '';
  };
}
