{config, ...}: {
  programs.fuzzel = {
    enable = !config.conf.headless && !config.conf.darwin;
    settings = {
      border.radius = 0;
    };
  };
}
