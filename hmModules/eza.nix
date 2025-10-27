{...}: {
  programs.eza = {
    enable = true;

    enableFishIntegration = true;
    icons = "auto";
    git = true;

    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--header"
      "--hyperlink"
    ];
  };
}
