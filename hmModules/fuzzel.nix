{config, ...}: {
  programs.fuzzel = {
    enable = !config.conf.headless && !config.conf.darwin;
    settings = {
      border.radius = 0;
      colors = {
        background = "282828ff";
        text = "ebdbb2ff";
        prompt = "ebdbb2ff";
        placeholder = "ebdbb2ff";
        input = "ebdbb2ff";
        match = "ebdbb2ff";
        selection = "ebdbb2ff";
        selection-text = "282828ff";
        selection-match = "282828ff";
        border = "ebdbb2ff";
      };
    };
  };
}
