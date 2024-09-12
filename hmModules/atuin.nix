{sysConfig, ...}: {
  programs.atuin = {
    enable = !sysConfig.work;
    enableFishIntegration = !sysConfig.work;

    flags = ["--disable-up-arrow"];

    settings = {
      style = "compact";
      show_help = false;
      inline_height = 13;
      invert = true;
      enter_accept = true;

      # not working?
      ctrl_n_shortcuts = true;
    };
  };
}
