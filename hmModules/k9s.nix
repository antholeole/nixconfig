{...}: {
  programs.k9s = {
    enable = true;

    settings = {
      skin = "gruvbox-dark";

      ui = {
        headless = true;
        logoless = true;
      };

      skipLatestRevCheck = true;
    };
  };
}
