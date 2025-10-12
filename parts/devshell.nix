{...}: {
  perSystem = {
    system,
    pkgs,
    lib,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.flake-root.devShell];

      shellHook = ''
        export QML2_IMPORT_PATH=${lib.concatStringsSep ":" [
          "${pkgs.quickshell}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
          "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
          "$FLAKE_ROOT/confs/quickshell"
        ]}
      '';

      packages = [
        # cant use inputs from. buildNpmPackage does not work with nodejs24
        pkgs.nodejs_24
        pkgs.quickshell
      ];
    };
  };
}
