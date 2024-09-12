{
  pkgs,
  config,
  ...
}: {
  programs.gh-dash = {enable = true;};

  programs.gh = {
    enable = true;

    settings = {
      editor = pkgs.lib.getExe config.programs.kakoune.package;
      git_protocol = "ssh";
    };
  };
}
