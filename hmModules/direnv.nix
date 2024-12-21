{...}: {
  programs.direnv = {
    enable = true;

    # this makes things more difficult
    nix-direnv.enable = false;
  };
}
