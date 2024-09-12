{
  lib,
  sysConfig,
  pkgs,
  inputs,
  oleinaNixpkgs,
  systemClip,
  ...
}: let
  kakWithHop = oleinaNixpkgs.kakoune.override {
    plugins = with pkgs.kakounePlugins; [
      fzf-kak
      quickscope-kak
      oleinaNixpkgs.kakounePlugins.hop-kak
    ];
  };
in {
  options.programs.my-kakoune.package = with lib;
    mkOption {
      type = types.package;
      default = kakWithHop;
    };

  config = {
    home.packages = [kakWithHop];

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

          colorscheme catppuccin_macchiato

          # add copy to system clipboard
          hook global RegisterModified '"' %{ nop %sh{
            printf %s "$kak_main_reg_dquote" | ${systemClip.copy}${
            if sysConfig.headless
            then ""
            else " > /dev/null 2>&1 &"
          }
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

      ".config/kak/colors/catppuccin_macchiato.kak".source = "${inputs.self}/confs/kak/catppuccin_macchiato.kak";
      ".config/kak-lsp/kak-lsp.toml".source = "${inputs.self}/confs/kak/kak-lsp.toml";
    };
  };
}
