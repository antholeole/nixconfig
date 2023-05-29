{ inputs, pkgs, ... }: {
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      ${pkgs.neofetch.outPath}/bin/neofetch;

      eval "$(starship init bash)";
      function cdc { mkdir -p $1 && cd $1; };
    '';
  };
}
