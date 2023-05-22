{ inputs, pkgs }: {
  enable = true;

  bashrcExtra = ''
    eval "$(starship init bash)";
    function cdc { mkdir -p $1 && cd $1; };
  '';
}
