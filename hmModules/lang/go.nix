{ pkgs, ... }: {
  home.packages = with pkgs; [
    gopls
    go
  ];
}
