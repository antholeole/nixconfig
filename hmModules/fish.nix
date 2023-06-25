{ inputs, pkgs, ... }: let 
    xclipPath = "${pkgs.xclip.outPath}/bin/xclip";
in {
  programs.fish = {
    enable = true;

    shellAbbrs = {
      c ="${xclipPath} -selection clipboard";
      v = "${xclipPath} -o -selection clipboard";
    };

    functions = {
      cdc = "mkdir -p $argv && cd $argv";
    };

    interactiveShellInit = ''
      set fish_greeting
      ${pkgs.neofetch.outPath}/bin/neofetch
   '';
  };
  # on systems where we cannot configure the default shell, it helps to write
  # a bashrc to start fish, so we can use it anyway
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      fish; 
    '';
  };
}
