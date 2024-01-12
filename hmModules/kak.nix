{ pkgs, inputs, systemCopy, ... }: {
  programs.kakoune = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.kakounePlugins; [ fzf-kak quickscope-kak ];
    config = {
      hooks = [
        {
          name = "ModuleLoaded";
          once = true;
          option = "fzf-file";
          commands = ''
            set-option global fzf_file_command '${pkgs.fd}/bin/fd --type f'
            set-option global fzf_highlight_command '${pkgs.bat}/bin/bat'
          '';
        }
        {
          name = "ModuleLoaded";
          once = true;
          option = "fzf-grep";
          commands = ''
            set-option global fzf_grep_command '${pkgs.ripgrep}/bin/rg'
          '';
        }
      ];
    };

    extraConfig = with pkgs; ''
      eval %sh{${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}


      # line numbers
      add-highlighter global/ number-lines -relative

      # color scheme
      colorscheme catppuccin_macchiato

      # add copy to system clipboard
      hook global RegisterModified '"' %{ nop %sh{
            printf %s "$kak_main_reg_dquote" | ${systemCopy} > /dev/null 2>&1 &
      }}

      # add paste to system clipboard
      map global user P '!${wl-clipboard}/bin/wl-paste -n<ret>'
      map global user p '<a-!>${wl-clipboard}/bin/wl-paste -n<ret>'

      map global normal <c-h> ': fzf-mode<ret>'
    '';
  };

  home.file.".config/kak/colors/catppuccin_macchiato.kak" = {
    enable = true;
    source = "${inputs.self}/confs/kak/catppuccin_macchiato.kak";
  };
}
