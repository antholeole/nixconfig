{
  pkgs,
  config,
  ...
}: {
  programs.obs-studio = {
    enable = !config.conf.headless && pkgs.system != "aarch64-linux" && !config.conf.darwin;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
