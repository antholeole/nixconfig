sysConfig: pkgs: pkg: with pkgs; writeShellApplication {
    name = (
      builtins.parseDrvName pkg.name).name;

    runtimeInputs = [ ];

    text =
      let
        sysNixGL = lib.getExe nixgl.auto.nixGLDefault;
      in
      ''
        exec ${sysNixGL} ${lib.getExe pkg} "$@"
      '';
  }
