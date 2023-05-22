vscode-extensions: {
  enable = true;
  extensions = with vscode-extensions; [
    # This is much better than the complex setup
    rust-lang.rust-analyzer
    catppuccin.catppuccin-vsc
    # catppuccin.catppuccin-vsc-icons
    yzhang.markdown-all-in-one
  ];

  keybindings = with builtins; fromJSON (readFile ./keybindings.json);
  userSettings = with builtins; fromJSON (readFile ./settings.json);
}
