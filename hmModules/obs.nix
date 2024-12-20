{
  pkgs,
  config,
  ...
}: {
  programs.obs-studio = {
    enable = !config.conf.headless;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
