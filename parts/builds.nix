{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.vsce = (import "${inputs.self}/confs/vscext") pkgs;
  };
}
