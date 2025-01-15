pkgs: let
  name = "vsc-ext";
  version = "0.0.1";

  vsix = pkgs.stdenv.mkDerivation {
    inherit version;

    pname = "${name}-vsix";
    src = ./.;

    buildInputs = with pkgs; [
      vsce
      nodejs_23
    ];

    buildPhase = ''
      runHook preBuild

      vsce package --allow-missing-repository --skip-license -o ${name}.zip
      mkdir -p $out
      mv ${name}.zip $out

      runHook postBuild
    '';
  };
in
  pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      inherit name version;
      publisher = "oleina";
    };

    vsix = "${vsix}/${name}.zip";
  }
