{
  config,
  ...
}: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home = {
    username = config.conf.name;
    homeDirectory = "${config.conf.homeDirPath}${config.conf.name}";

    # TODO: remove this. did it for quickshell
    enableNixpkgsReleaseCheck = false;
  };

  home.stateVersion = "23.05";
}
