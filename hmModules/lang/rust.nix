{ pkgs, ... }:
let
  rust-toolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain:
    toolchain.default.override {
      extensions = ["rustfmt" "rust-analyzer" "rust-src" "cargo" "rustc"];
      targets = ["x86_64-unknown-linux-gnu"];
    });
in
{
  home.packages = [
    rust-toolchain
  ];

  programs.helix.languages = {
    language-server = {
      rust-analyzer.command = "rust-analyzer";
    };
  };
}
