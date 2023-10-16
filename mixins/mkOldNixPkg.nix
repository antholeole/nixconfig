{ pkgSha, pkgsetHash }: let
    pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${pkgsetHash}.tar.gz";
}) {
config.allowUnfree = true;
};
in pkgs


