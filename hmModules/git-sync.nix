{ config, ... }: {
  services.git-sync = {
    enable = true;
    repositories = {
      notebook = {
        uri = "git@github.com:antholeole/notebook.git";
        path = config.home.homeDirectory + "/Notes";
      };
    };
  };
}
