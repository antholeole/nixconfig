{ pkgs, inputs, systemCopy, ... }: {
  programs.kakoune = {
    enable = true;

    
    extraConfig = ''
      eval %sh{${pkgs.kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}

      hook global RegisterModified '"' %{ nop %sh{
            printf %s "$kak_main_reg_dquote" | ${systemCopy} > /dev/null 2>&1 &
      }}

      map global user P '!${pkgs.wl-clipboard}/bin/wl-paste<ret>'
      map global user p '<a-!>${pkgs.wl-clipboard}/bin/wl-paste<ret>'

    '';
  };
}
