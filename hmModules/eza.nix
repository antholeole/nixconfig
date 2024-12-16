{...}: {
  programs.eza = {
    enable = true;

    enableFishIntegration = true;
    icons = "auto";

    extraOptions = ["--group-directories-first" "--header"];
  };
}
