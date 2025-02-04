{
  pkgs,
  config,
  ...
}: {
  programs.gh = {
    enable = true;

    settings = {
      editor = pkgs.lib.getExe config.programs.helix.package;
      git_protocol = "ssh";
    };
  };
}
