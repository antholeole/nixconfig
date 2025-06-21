{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages =
      {
        rcclient-server = (import "${inputs.self}/confs/services/clipboard" pkgs).server;
      }
      // (import "${inputs.self}/programs/zx" pkgs);
  };
}
