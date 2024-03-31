{ pkgs, ... }: {
  # unfortunately, for vscode extensions, executables need to be
  # on PATH. So we need these packages to be installed globally. 
  home.packages = with pkgs; [
    gcc
    nixpkgs-fmt
    picat
  ];
}
