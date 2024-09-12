{
  inputs,
  pkgs,
  config,
  systemClip,
  sysConfig,
  lib,
  ...
}: {
  programs.fish = let
    remoteClipClient =
      (import "${inputs.self}/confs/services/clipboard" pkgs).client;

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

    shellAliases = let
      cv =
        if sysConfig.headless
        then {
          cliphist = remoteClipClient.cliphist;
          done = remoteClipClient.done;
        }
        else {
          done = "${pkgs.libnotify}/bin/notify-send done!";
        };
    in
      {
        c = systemClip.copy;
        v = systemClip.paste;

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

        # unfortunatly an alias leads to infinite recursion
        # TODO: is this not required because of enable fish
        # integration?
        cd = "z";

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

    functions = with pkgs; let
      fzfExe = lib.getExe config.programs.fzf.package;
    in
      {
        cdc = "mkdir -p $argv && cd $argv";
        rmt = "${trashy}/bin/trash put $argv";
        zd = "${zoxide}/bin/zoxide query $argv";
        hmWhich = "echo $(dirname $(dirname $(readlink -f $(which $argv))))";
        sshdc = "rm ~/.ssh/ctrl-*";
        cdb = "for i in (seq 1 $argv); cd ..; end";
        skak = "sudo ${kakoune}/bin/kak $argv";
        bazel = "${pkgs.bazelisk}/bin/bazelisk $argv";

        gacp = let
          git = "${config.programs.git.package}/bin/git";
        in "${git} add --all && ${git} commit -m $argv && ${git} push";

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

        ch = let
          sysCliphist =
            if sysConfig.headless
            then remoteClipClient.cliphist
            else "${lib.getExe cliphist} list";
        in "${sysCliphist} | ${fzfExe} -d '\\t' --with-nth 2 --height 8 | ${
          lib.getExe cliphist
        } decode | ${systemClip.copy}";
      }
      // (lib.attrsets.concatMapAttrs (name: body: {
          "${name}" = body;
        })
        abbrFuns);

    plugins = let
      stdPlugins = [
        {
          name = "nix-env.fish";
          src = pkgs.fetchFromGitHub {
            owner = "lilyball";
            repo = "nix-env.fish";
            rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
            sha256 = "069ybzdj29s320wzdyxqjhmpm9ir5815yx6n522adav0z2nz8vs4";
          };
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
        if sysConfig.work
        then workPlugins
        else []
      );

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
