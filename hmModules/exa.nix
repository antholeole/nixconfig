{ ... }: {
  programs.exa = {
    enable = true;

    enableAliases = true;
    icons = true;

    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
