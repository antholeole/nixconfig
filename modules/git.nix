pkgs: {
  enable = true;

  extraConfig = {
    push.autoSetupRemote = true;
    init.defaultBranch = "main";

    # i am not so sure about dis
    pull.rebase = true; 

    user.name = "Anthony Oleinik";
  };
}
