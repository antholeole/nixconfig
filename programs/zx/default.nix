pkgs: let
  scripts = pkgs.buildNpmPackage {
    pname = "oleina-zx-scripts";
    version = "1.0.0";
    src = ./.;

    npmDepsHash = "sha256-GFgKjNi6d5hSYxanaNrlj4npTASgrDpVIspMKhyEsqo=";
    makeCacheWritable = true;
    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out/lib

      mv  node_modules/ $out/lib
      mv *.json $out/lib
      mv *.mts $out/lib
    '';
  };

  script = name:
    pkgs.writeShellApplication {
      inherit name;

      runtimeInputs = [
        scripts
        pkgs.niri
        pkgs.nodejs_24
      ];

      text = ''
        NODE_OPTIONS=--disable-warning=ExperimentalWarning ${pkgs.nodejs_24}/bin/node ${scripts}/lib/${name}.mts "$@"
      '';
    };
in {
  inherit scripts;

  fuzzel-omnibar = script "fuzzel-omnibar";
}
