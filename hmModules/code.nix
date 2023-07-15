{ pkgs, inputs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        # This is much better than the complex setup
        rust-lang.rust-analyzer
        # gregoire.dance :(
        # tobias-z.vscode-harpoon :(
        catppuccin.catppuccin-vsc
        # catppuccin.catppuccin-vsc-icons
        yzhang.markdown-all-in-one
      ];

    keybindings = with builtins; fromJSON (readFile "${inputs.self}/confs/code/keybindings.json");
    userSettings = with builtins; fromJSON (readFile "${inputs.self}/confs/code/settings.json");
  };
}
