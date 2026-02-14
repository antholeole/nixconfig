# https://github.com/donovanglover/nix-config/blob/54e3f6ed5b1f3f8dddd334f5d2bd68497658608f/home/dunst.nix#L4
{pkgs, ...}: {
  services.dunst = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    settings = {
      global = {
        follow = "keyboard";
        width = 370;
        separator_height = 1;
        padding = 24;
        horizontal_padding = 24;
        frame_width = 1;
        sort = "update";
        idle_threshold = 120;
        alignment = "center";
        word_wrap = "yes";
        transparency = 5;
        format = "<b>%s</b>: %b";
        markup = "full";
        min_icon_size = 32;
        max_icon_size = 128;
      };
    };
  };
}
