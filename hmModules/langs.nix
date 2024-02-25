{ pkgs, ... }: {
  # unfortunately, for vscode extensions, executables need to be
  # on PATH. So we need these packages to be installed globally. 
  home.packages = with pkgs; [
    gcc
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rust-src" ];
      targets = [ "wasm32-wasi" ];
    })
    nixpkgs-fmt
    picat
  ];
}
