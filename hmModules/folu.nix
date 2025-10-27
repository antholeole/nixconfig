{config, ...}: {
  xdg = {
    enable = !config.conf.darwin;
    userDirs = {
      enable = !config.conf.darwin;
      createDirectories = true;
    };
  };

  home = {
    username = config.conf.name;
    homeDirectory = "${config.conf.homeDirPath}${config.conf.name}";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "25.05";
  };
}
