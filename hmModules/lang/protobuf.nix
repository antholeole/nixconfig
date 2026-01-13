{ pkgs, ... }: {
  home.packages = with pkgs; [
    buf
  ];
}
