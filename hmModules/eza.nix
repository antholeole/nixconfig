{ ... }: {
  programs.eza = {
    enable = true;

    enableAliases = true;
    icons = true;

    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
