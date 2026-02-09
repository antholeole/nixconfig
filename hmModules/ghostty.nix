{
  config,
  pkgs-unstable,
  ...
}: {
  programs.ghostty = {
    enable = true;
    clearDefaultKeybinds = true;
    enableFishIntegration = true;
    package = pkgs-unstable.ghostty;

    settings = {
      command = "${config.programs.fish.package}/bin/fish";
      theme = "Gruvbox Dark";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 10;
      window-padding-x = 5;
      window-padding-y = 5;

      confirm-close-surface = false;

      keybind = [
        "ctrl+shift+equal=increase_font_size:1"
        "ctrl+equal=increase_font_size:1"
        "ctrl+plus=increase_font_size:1"

        "ctrl+minus=decrease_font_size:1"

        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        "ctrl+`=csi:23~"
      ];
    };
  };
}
