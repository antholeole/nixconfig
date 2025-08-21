pkgs:
pkgs.writeZxApplication {
  name = "ghbrowse";
  src = ./ghbrowse.mts;
  runtimeInputs = with pkgs; [git];
}
