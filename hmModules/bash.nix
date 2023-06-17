{ inputs, pkgs, ... }: {
  home.shellAliases = let 
    xclipPath = "${pkgs.xclip.outPath}/bin/xclip";
  in {
    c ="${xclipPath} -selection clipboard";
    v = "${xclipPath} -o -selection clipboard";
  };

  programs.bash = {
    enable = true;

    bashrcExtra = ''
      ${pkgs.neofetch.outPath}/bin/neofetch;

      eval "$(starship init bash)";
      function cdc { mkdir -p $1 && cd $1; };
    '';
  };
}
