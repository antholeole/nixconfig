sysConfig: pkgs: pkg: let 
     name = if pkg ? pname then pkg.pname else pkg.name;
in {
  xdg.dataFile."applications/${name}.desktop" = {
  enable = !sysConfig.headless;
  text = ''
     #!/usr/bin/env xdg-open
    [Desktop Entry]
    Version=1.0
    Terminal=false
    Type=Application
    Name=${name}
    Exec=${pkgs.lib.getExe pkg}
    Actions=New-Window
  '';
};}
