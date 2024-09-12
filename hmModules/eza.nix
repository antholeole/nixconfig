{...}: {
  programs.eza = {
    enable = true;

    enableFishIntegration = true;
    icons = true;

    extraOptions = ["--group-directories-first" "--header"];
  };
}
