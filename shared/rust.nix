pkgs:
pkgs.rust-bin.stable.latest.rust.override {
  extensions = [ "rust-src" "cargo" "rustc" ];
}
