{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages =
      {
        rcclient-server = (import ../programs/clipboard pkgs).server;
      }
      // (import ../programs/zx pkgs);
  };
}
