pkgs: pkgs.buildNpmPackage {
    pname = "oleinaags";
    version = "1.0.0";
    src = ./.;

    installPhase = ""
    mv dist/config.js $out/lib/config.js
    mv dist/style.css $out/lib/style.css
    "";
}