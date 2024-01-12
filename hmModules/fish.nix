{ inputs, pkgs, config, systemCopy, sysConfig, lib, ... }:
let wlClipPath = "${pkgs.wl-clipboard.outPath}/bin/";
in {
  programs.fish = let
    remoteClipClient =
      (import "${inputs.self}/confs/services/clipboard" pkgs).client;
  in {
    enable = true;

    shellAliases = let
      cv = if sysConfig.headless then {
        c = remoteClipClient.copy;
        v = remoteClipClient.paste;
        done = remoteClipClient.done;
      } else {
        c = systemCopy;
        v = "${wlClipPath}wl-paste";
        done = "${pkgs.libnotify}/bin/notify-send done!";
      };
    in { rd = "rm -rf"; } // cv;

    shellAbbrs = { pl = "parallel"; };

    functions = with pkgs;
      let fzfExe = lib.getExe config.programs.fzf.package;
      in {
        cdc = "mkdir -p $argv && cd $argv";
        rmt = "${trashy}/bin/trash put $argv";
        killp = "kill (lsof -t -i:$argv)";
        zd = "${zoxide}/bin/zoxide query $argv";
        hmWhich = "echo $(dirname $(dirname $(readlink -f $(which $argv))))";
        sshdc = "rm ~/.ssh/ctrl-*";
        cdb = "for i in (seq 1 $argv); cd ..; end";
        skak = "sudo ${kakoune}/bin/kak $argv";

        gacp = let git = "${config.programs.git.package}/bin/git";
        in "${git} add --all && ${git} commit -m $argv && ${git} push";

        ch = let
          sysCliphist = if sysConfig.headless then
            remoteClipClient.cliphist
          else
            "${lib.getExe cliphist} list";
        in "${sysCliphist} | ${fzfExe} -d '\\t' --with-nth 2 --height 8 | ${
          lib.getExe cliphist
        } decode | ${wlClipPath}wl-copy";
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

      fish_add_path ~/.config/git

      # this is probably dumb
      ${pkgs.toybox}/bin/yes | fish_config theme save "catppuccin-macchiato"

      set MICRO_TRUECOLOR 1
    '';
  };

  home.file.".config/fish/themes/catppuccin-macchiato.theme" = {
    enable = true;
    source = "${inputs.self}/confs/fish/catppuccin-macchiato.theme";
  };
}
