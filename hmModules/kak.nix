{ pkgs, inputs, oleinaNixpkgs, systemClip, ... }: {
  home.packages = [
    (oleinaNixpkgs.kakoune.override {
      plugins = with pkgs.kakounePlugins; [ 
      fzf-kak 
      quickscope-kak 
      oleinaNixpkgs.kakounePlugins.hop-kak
    ];
    })
  ]; 

  home.file = {
    ".config/kak/kakrc" = {
      enable = true;
      text = ''
hook  global WinCreate ^[^*]+$ %{ git show-diff }
hook  -once global ModuleLoaded fzf-grep %{       
  set-option global fzf_grep_command '${pkgs.ripgrep}/bin/rg'
  set-option global fzf_file_command '${pkgs.fd}bin/fd --type f'
  set-option global fzf_highlight_command '${pkgs.bat}/bin/bat'
  map global normal <c-e> ': fzf-mode<ret>'
	set-option global fzf-file ${pkgs.bat}/bin/bat
}

lsp-enable

colorscheme catppuccin_macchiato

# add copy to system clipboard
hook global RegisterModified '"' %{ nop %sh{
      printf %s "$kak_main_reg_dquote" | ${systemClip.copy} > /dev/null 2>&1 &
}}

# add paste to system clipboard
map global user P '${systemClip.paste} -n<ret>'
map global user p '<a-!>${systemClip.paste}<ret>'

# configure hop
evaluate-commands %sh{ hop-kak --init }
declare-option str hop_kak_keyset 'abcdefghijklmnopqrstuvwxyz'
define-command hop-kak %{
   eval -no-hooks -- %sh{ hop-kak --keyset "$kak_opt_hop_kak_keyset" --sels "$kak_selections_desc" }
}
define-command -override hop-kak-words %{
   exec 'gtGbxs\w+<ret>:eval -no-hooks -- %sh{ hop-kak --keyset "$kak_opt_hop_kak_keyset" --sels "$kak_selections_desc" }<ret>'
 }
 map global normal s :hop-kak-words<ret>


      '';
    };
  };

  programs.kakoune = {
    enable = false;
    defaultEditor = true;

    config = {
      hooks = [
        {
        name = "WinCreate";
        option = "^[^*]+$";
        commands = ''
          git show-diff
        '';
      }
        {
          name = "ModuleLoaded";
          once = true;
          option = "fzf-grep";
          commands = ''
            set-option global fzf_grep_command '${pkgs.ripgrep}/bin/rg'
            set-option global fzf_file_command '${pkgs.fd}/bin/fd --type f'
            set-option global fzf_highlight_command '${pkgs.bat}/bin/bat'
          	map global normal <c-e> ': fzf-mode<ret>'
      	    set-option global fzf-file ${pkgs.bat}/bin/bat
          '';
        }
     ];
    };

    extraConfig = with pkgs; ''
      echo -debug "extraconfig"
      eval %sh{${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}
      lsp-enable

      

      # color scheme
      colorscheme catppuccin_macchiato

      # add copy to system clipboard
      hook global RegisterModified '"' %{ nop %sh{
            printf %s "$kak_main_reg_dquote" | ${systemCopy} > /dev/null 2>&1 &
      }}

      # add paste to system clipboard
      map global user P '!${wl-clipboard}/bin/wl-paste -n<ret>'
      map global user p '<a-!>${wl-clipboard}/bin/wl-paste -n<ret>'

      # TODO this requires a usermode so that we don't collide keybindings while hopping
      # configure hop
      evaluate-commands %sh{ hop-kak --init }
      declare-option str hop_kak_keyset 'abcdefghijklmnopqrstuvwxyz'
      define-command hop-kak %{
         eval -no-hooks -- %sh{ hop-kak --keyset "$kak_opt_hop_kak_keyset" --sels "$kak_selections_desc" }
      }
      define-command -override hop-kak-words %{
         exec 'gtGbxs\w+<ret>:eval -no-hooks -- %sh{ hop-kak --keyset "$kak_opt_hop_kak_keyset" --sels "$kak_selections_desc" }<ret>'
       }
       map global normal s :hop-kak-words<ret>
    '';
  };

  home.file = {
    ".config/kak/colors/catppuccin_macchiato.kak".source =
      "${inputs.self}/confs/kak/catppuccin_macchiato.kak";
    ".config/kak-lsp/kak-lsp.toml".source =
      "${inputs.self}/confs/kak/kak-lsp.toml";
  };
}
