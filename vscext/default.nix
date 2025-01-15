pkgs:
pkgs.vscode-utils.buildVscodeExtension rec {
  name = "vsc-ext";
  src = ./.;
  version = "0.0.1";
  vscodeExtPublisher = "oleina";
  vscodeExtName = "a";
  vscodeExtUniqueId = "${vscodeExtPublisher}.${vscodeExtName}";

  buildInputs = with pkgs; [
    vsce
    nodejs_23
  ];

  buildPhase = ''
    runHook preBuild

    vsce package --allow-missing-repository --skip-license
    mkdir -p $out/share/vscode/extensions
    cp *.vsix $out/share/vscode/extensions

    runHook postBuild
  '';
}
