{...}: {
  programs.k9s = {
    enable = true;

    settings.k9s = {
      skin = "gruvbox-dark";

      ui = {
        headless = true;
        logoless = true;
      };

      skipLatestRevCheck = true;
    };
  };
}
