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
      mv *.mts $out/lib
      mv package.json $out/lib
    '';
  };

  script = name:
    pkgs.writeTextFile {
      inherit name;
      executable = true;
      # todo disable warning
      text = ''
        #!${pkgs.nodejs_24}/bin/node ${scripts}/lib/${name}.mts
      '';
      meta.mainProgram = name;
    };
in {
  inherit scripts;

  fuzzel-omnibar = script "fuzzel-omnibar";
}
