{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages =
      {
        rcclient-server = (import "${inputs.self}/programs/clipboard" pkgs).server;
      }
      // (import "${inputs.self}/programs/zx" pkgs);
  };
}
