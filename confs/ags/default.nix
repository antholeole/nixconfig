pkgs: pkgs.buildNpmPackage {
    pname = "oleinaags";
    version = "1.0.0";
    src = pkgs.buildEnv {
        name = "fqoleinaags";
        paths = [ 
            (pkgs.nix-gitignore.gitignoreSource [] ./.)
            "${pkgs.ags}/share/com.github.Aylur.ags/" 
        ];
    };

    npmDepsHash = "sha256-cepYvhgSl2caPDF0HBdjo2fqNf6m2QkJWz/o0gkQOw8=";

    configurePhase = ''
    # replace the sass in the npm deps with the one off nixpkgs, which 
    # does not default to embedded.
    rm -rf node_modules/sass*
    cp -r ${pkgs.nodePackages.sass}/lib/node_modules/sass node_modules/sass
    rm config.js
    '';


    installPhase = ''
    mkdir -p $out/lib
    mv dist/config.js $out/lib/config.js
    mv dist/style.css $out/lib/style.css
    '';
}