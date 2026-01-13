{
  pkgs,
  config,
  inputs,
  ...
}: {
  programs.helix = {
    package = pkgs.helix;
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "gruvbox";

      keys = {
        normal = {
          ret = "goto_word";
          space = {
            F = "file_picker";
            f = "file_picker_in_current_buffer_directory";
            E = [
              ":sh rm -f /tmp/unique-file"
              ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
              ":insert-output echo \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
              ":open %sh{cat /tmp/unique-file}"
              ":redraw"
            ];

            e = "file_explorer_in_current_buffer_directory";

            space = {
              b = ''
                :sh jj file annotate %{buffer_name} -T 'commit.author().name() ++ ", " ++ commit.author().timestamp().ago() ++ " @ " ++ commit.commit_id() ++ " (" ++ commit.change_id().shortest() ++ ") " ++"\n"' --color=never | sed -n '%{cursor_line}p'
              '';

            p = ''
              :sh echo %{buffer_name} | ${config.programs.system-clip.package} copy
              '';
            };
          };
        };
      };

      editor = {
        line-number = "relative";
        rulers = [80];
        jump-label-alphabet = "hjklabcdefgimnopqrstuvwxyz";
        soft-wrap.enable = true;
        true-color = true;
        cursorline = true;

        file-picker = {
          # always show hidden files, these are often useful
          hidden = false;
          # do not respect the gitignore; its helpful to see generated files.
          git-ignore = false;
          # do respect our manual ignore files.
          ignore = true;
        };

        lsp = {
          display-inlay-hints = true;
        };

        auto-save.after-delay.timeout = 3000;

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };

        clipboard-provider =
          if (!config.conf.headless)
          then
            (
              if (!config.conf.darwin)
              then "wayland"
              else "pasteboard"
            )
          else {
            custom = with config.programs.system-clip; {
              yank = {
                command = package;
                args = ["paste"];
              };
              paste = {
                command = package;
                args = ["copy"];
              };
            };
          };
      };
    };

    ignores = import "${inputs.self}/shared/ignores.nix";
  };
}
