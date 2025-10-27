{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  programs.fish = let
    remoteClipClient =
      (import ../programs/clipboard pkgs).client;

    # execute the given command on an abbreviation
    abbrFuns =
      {
        "!!" = "echo $history[1]";
        "!@" = "commandline -f history-token-search-backward";
      }
      // lib.attrsets.mergeAttrsList (builtins.map (idx: {
        "!${builtins.toString idx}" = "echo $history[${builtins.toString idx}]";
      }) (lib.lists.range 1 9));
  in {
    enable = true;
    package = pkgs.fish.override {
      fishEnvPreInit = source: source "${pkgs.nix}/etc/profile.d/nix-daemon.sh";
    };

    shellAliases = let
      cv =
        if config.conf.headless
        then {
          done = remoteClipClient.done;
        }
        else {
          done = "${pkgs.libnotify}/bin/notify-send done!";
        };
    in
      {
        c = config.programs.system-clip.copy;
        v = config.programs.system-clip.paste;

        rd = "rm -rf";
        zedit = "${pkgs.zellij}/bin/zellij --layout zedit";
        awk = "${pkgs.gawk}/bin/gawk";

        # last command duration
        ldc = "humantime $CMD_DURATION";

        # list all the conflicts
        gcn = "git conflicts";
      }
      // cv;

    shellAbbrs =
      {
        pl = "parallel";

        # expand cuz I can never remember
        ct = "command-tab";

        # git diff for patch
        gdp = "git diff --no-ext-diff";

        # git create change list
        gccl = "git cl";
      }
      // (lib.attrsets.concatMapAttrs (name: _: {
          "${name}" = {
            position = "anywhere";
            function = name;
          };
        })
        abbrFuns);

    functions = with pkgs;
      {
        cdc = "mkdir -p $argv && cd $argv";
        zd = "${zoxide}/bin/zoxide query $argv";
        hmWhich = "echo $(dirname $(dirname $(readlink -f $(which $argv))))";
        sshdc = "rm ~/.ssh/ctrl-*";
        cdb = "for i in (seq 1 $argv); cd ..; end";
        bazel = "${pkgs.bazelisk}/bin/bazelisk $argv";

        manopt = ''
          set -l cmd $argv[1]
          set -l opt $argv[2]
          if not echo $opt | grep '^-' >/dev/null
            if [ (string length $opt) = 1 ]
              set opt "-$opt"
            else
              set opt "--$opt"
            end
          end
          man "$cmd" | col -b | awk -v opt="$opt" -v RS= '$0 ~ "(^|,)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
        '';
      }
      // (lib.attrsets.concatMapAttrs (name: body: {
          "${name}" = body;
        })
        abbrFuns);

    plugins = let
      stdPlugins = [
        {
          name = "gruvbox";
          src = pkgs.fishPlugins.gruvbox.src;
        }
        {
          name = "humantime-fish";
          src = pkgs.fishPlugins.humantime-fish.src;
        }
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
      ];

      workPlugins = [
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "6d8e962f3ed84e42583cec1ec4861d4f0e6c4eb3";
            sha256 = "sha256-0rnd8oJzLw8x/U7OLqoOMQpK81gRc7DTxZRSHxN9YlM";
          };
        }
      ];
    in
      stdPlugins
      ++ (
        if config.conf.work
        then workPlugins
        else []
      );

    interactiveShellInit = ''
      set fish_greeting
      set EDITOR ${config.programs.helix.package}/bin/hx

      fish_add_path ~/.config/git
    '';
  };
}
