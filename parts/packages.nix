{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.rcclient-server = (import "${inputs.self}/confs/services/clipboard" pkgs).server;
  };
}
