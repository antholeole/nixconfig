{ inputs, pkgs, ... }:
let
  wlClipPath = "${pkgs.wl-clipboard.outPath}/bin/";
in
{
  programs.fish = {
    enable = true;

    shellAliases = {
      c = "${wlClipPath}wl-copy";
      v = "${wlClipPath}wl-paste";
      rd = "rm -rf";
    };

    functions = {
      cdc = "mkdir -p $argv && cd $argv";
      rmt = "${pkgs.trashy}/bin/trash put $argv";
      killp = "kill (lsof -t -i:$argv)";
      zd = "${pkgs.zoxide}/bin/zoxide query $argv";
      hmWhich = "echo $(dirname $(dirname $(readlink -f $(which $argv))))";
      sshdc = "rm ~/.ssh/ctrl-*";
    };

    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "6d8e962f3ed84e42583cec1ec4861d4f0e6c4eb3";
          sha256 = "sha256-0rnd8oJzLw8x/U7OLqoOMQpK81gRc7DTxZRSHxN9YlM";
        };
      }
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
      set EDITOR ${pkgs.kakoune}/bin/kak

      if not set -q ZELLIJ                                                                                                                                                                                                                                                          
        if test "$ZELLIJ_AUTO_ATTACH" = "true"                                                                                                                                                                                                                                    
          zellij attach -c                                                                                                                                                                                                                                                      
        else
          set -q ZELLIJ_LAYOUT || set ZELLIJ_LAYOUT "default"
          zellij --layout $ZELLIJ_LAYOUT
        end                                                                                                                                                                                                                                                                       
        if test "$ZELLIJ_AUTO_EXIT" = "true"                                                                                                                                                                                                                                      
            kill $fish_pid                                                                                                                                                                                                                                                        
        end                                                                                                                                                                                                                                                                       
      end  

      ${pkgs.neofetch.outPath}/bin/neofetch
    '';
  };
}
