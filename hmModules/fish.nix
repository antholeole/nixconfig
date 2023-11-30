{ inputs, pkgs, config, systemCopy, sysConfig, lib, ... }:
let wlClipPath = "${pkgs.wl-clipboard.outPath}/bin/";
in {
  programs.fish = {
    enable = true;

    shellAliases = {
      # TODO this should be bidirectional
      c = systemCopy;
      v = "${wlClipPath}wl-paste";
      rd = "rm -rf";
    };

    functions = with pkgs; let 
      fzfExe = lib.getExe config.programs.fzf.package;
    in {
      cdc = "mkdir -p $argv && cd $argv";
      rmt = "${trashy}/bin/trash put $argv";
      killp = "kill (lsof -t -i:$argv)";
      zd = "${zoxide}/bin/zoxide query $argv";
      hmWhich = "echo $(dirname $(dirname $(readlink -f $(which $argv))))";
      sshdc = "rm ~/.ssh/ctrl-*";
      cdb = "for i in (seq 1 $argv); cd ..; end";
      ch = "${lib.getExe cliphist} list | ${fzfExe} -d '\\t' --with-nth 2 --height 8 | ${lib.getExe cliphist} decode | ${wlClipPath}wl-copy";
      iforgot = "cat ~/.config/other/often_forgotten.md | ${fzfExe} --height 8";
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
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
    ];

    shellInit = ''
      source ~/.nix-profile/etc/profile.d/nix.fish
    '';

    interactiveShellInit = ''
      set fish_greeting
      set EDITOR ${pkgs.kakoune}/bin/kak
      eval $(${pkgs.lib.getExe pkgs.watchexec} --completions fish)

      set MICRO_TRUECOLOR 1


    '';
  };
}
