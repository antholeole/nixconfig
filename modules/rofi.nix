{ pkgs, ... }: {
  home-manager.users.anthony.programs.rofi = {
    enable = true;

    terminal = "${pkgs.alacritty}/bin/gnome-terminal";
  };
}