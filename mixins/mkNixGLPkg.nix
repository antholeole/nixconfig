sysConfig: pkgs: pkg: with pkgs;
if sysConfig.nixgl == null
then
  pkg
else
  writeShellApplication {
    name = (
      builtins.parseDrvName pkg.name).name;

    runtimeInputs = [ ];

    text =
      let
        sysNixGL = lib.getExe nixgl.auto."nixGL${sysConfig.nixgl}";
      in
      ''
        exec ${sysNixGL} ${lib.getExe pkg} "$@"
      '';
  }
