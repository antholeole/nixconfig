{ pkgs, ...}: {
  home-manager.users.anthony.programs.git = {
    enable = true;

    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";

      user.name = "Anthony Oleinik";
    };
  };
}