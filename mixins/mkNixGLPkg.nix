sysConfig: pkgs: pkg: exeName:
with pkgs;
writeShellApplication {
  name = (builtins.parseDrvName pkg.name).name;

  runtimeInputs = [ ];

  text = let sysNixGL = lib.getExe nixgl.auto.nixGLDefault;
  in ''
    ${sysNixGL} ${lib.getExe' pkg exeName} "$@"
  '';
}
