{ pkgs, inputs, systemCopy, ... }: {
  programs.kakoune = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.kakounePlugins; [
      fzf-kak
      quickscope-kak
    ];

    extraConfig = ''
      eval %sh{${pkgs.kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}


      # line numbers
      add-highlighter global/ number-lines -relative

      # color scheme
      colorscheme catppuccin_macchiato

      # add copy to system clipboard
      hook global RegisterModified '"' %{ nop %sh{
            printf %s "$kak_main_reg_dquote" | ${systemCopy} > /dev/null 2>&1 &
      }}

      # add paste to system clipboard
      map global user P '!${pkgs.wl-clipboard}/bin/wl-paste<ret>'
      map global user p '<a-!>${pkgs.wl-clipboard}/bin/wl-paste<ret>'

      map global normal <c-h> ': fzf-mode<ret>'

      # ignore some garbage
      set-option global fzf_file_command "${pkgs.fd}/bin/fd . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print"
    '';
  };

  home.file.".config/kak/colors/catppuccin_macchiato.kak" = {
    enable = true;
    source = "${inputs.self}/confs/kak/catppuccin_macchiato.kak";
  };
}
