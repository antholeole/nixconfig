{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  programs.fish = let
    remoteClipClient =
      (import "${inputs.self}/programs/clipboard" pkgs).client;

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
        ldc = "humantime $CMD_DURATION | awk '{$1=\"\"; print $0}'";
        ssh-killold = "pgrep -u $USER sshd | grep -v $(pgrep -u $USER -n sshd) | xargs -r kill";
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

      theme_gruvbox dark medium
      fish_config theme choose Gruvbox

      fish_add_path ~/.config/git
    '';
  };

  xdg.configFile."fish/themes/Gruvbox.theme" = with config.colorScheme.palette; {
    enable = true;
    text = let
      foreground = base07;
      selection = base04;
      comment = base03;
      red = base08;
      orange = base09;
      yellow = base0A;
      green = base0B;
      purple = base0E;
      cyan = base0C;
      blue = base0D;
    in ''
      # name: 'Dracula'
      # license: 'MIT'
      # preferred_background: 282a36
      #
      # Foreground: ${foreground}
      # Selection: ${selection}
      # Comment: ${comment}
      # Red: ${red}
      # Orange: ${orange}
      # Yellow: ${yellow}
      # Green: ${green}
      # Purple: ${purple}
      # Cyan: ${cyan}
      # Blue: ${blue}

      fish_color_normal ${foreground}
      fish_color_command ${cyan}
      fish_color_quote ${yellow}
      fish_color_redirection ${foreground}
      fish_color_end ${orange}
      fish_color_error ${red}
      fish_color_param ${purple}
      fish_color_comment ${comment}
      fish_color_match --background=brblue
      fish_color_selection --background=${selection}
      fish_color_search_match --background=${selection}
      fish_color_history_current --bold
      fish_color_operator ${green}
      fish_color_escape ${blue}
      fish_color_cwd ${green}
      fish_color_cwd_root red
      fish_color_valid_path --underline
      fish_color_autosuggestion ${comment}
      fish_color_user ${cyan}
      fish_color_host ${purple}
      fish_color_cancel ${red} --reverse
      fish_pager_color_completion ${foreground}
      fish_pager_color_description ${comment}
      fish_pager_color_prefix ${cyan}
      fish_pager_color_progress ${comment}
      fish_pager_color_selected_background --background=${selection}
      fish_color_option ${orange}
      fish_color_keyword ${blue}
      fish_color_host_remote ${purple}
      fish_color_status ${red}

      fish_pager_color_background
      fish_pager_color_selected_prefix ${cyan}
      fish_pager_color_selected_completion ${foreground}
      fish_pager_color_selected_description ${comment}
      fish_pager_color_secondary_background
      fish_pager_color_secondary_prefix ${cyan}
      fish_pager_color_secondary_completion ${foreground}
      fish_pager_color_secondary_description ${comment}
    '';
  };
}
