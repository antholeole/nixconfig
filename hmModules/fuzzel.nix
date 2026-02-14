{
  config,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = !config.conf.headless && !config.conf.darwin;
    settings.main = {
      font = lib.mkForce "${config.stylix.fonts.monospace.name}";
    };
  };
}
