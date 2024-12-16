{
  pkgs,
  config,
  ...
}: {
  programs.gh = {
    enable = true;

    settings = {
      editor = pkgs.lib.getExe config.programs.kakoune.package;
      git_protocol = "ssh";
    };
  };
}
