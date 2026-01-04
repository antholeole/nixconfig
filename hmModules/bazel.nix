{pkgs, ...}: {
  home.packages = let
    bazelisk = pkgs.writeShellScriptBin "bazel" ''
      ${pkgs.bazelisk}/bin/bazelisk "$@"
    '';
  in [
    bazelisk
  ];
}
