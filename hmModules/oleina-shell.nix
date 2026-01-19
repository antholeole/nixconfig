{config, ...}: {
  services.oleina-shell.enable =
    !config.conf.headless && !config.conf.darwin;
}
