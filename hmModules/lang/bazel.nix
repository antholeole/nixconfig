{ pkgs, lib, ... }:
let
  isArm = pkgs.system == "aarch64-linux";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "bazel" ''
      ${pkgs.bazelisk}/bin/bazelisk "$@"
    '')
  ] ++ lib.optional (!isArm) pkgs.starpls-bin;

  programs.helix.languages = {
    language = [
      {
        name = "starlark";
        language-servers = [
          "starpls"
        ];
        formatter.command = "${pkgs.bazel-buildtools}/bin/buildifier";
      }
    ];
  };
}
