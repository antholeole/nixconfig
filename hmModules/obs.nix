{
  pkgs,
  config,
  ...
}: {
  programs.obs-studio = {
    enable = !config.conf.headless && pkgs.system != "aarch64-linux";
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
