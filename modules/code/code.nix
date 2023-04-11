{ pkgs, ... }: {
  home-manager.users.anthony.programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      # catppuccin.catppuccin-vsc-icons
      yzhang.markdown-all-in-one
    ];
  };
}