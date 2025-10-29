{config, ...}: {
  hardware.graphics = {
    enable = true;
  };

  boot.initrd.kernelModules = lib.mkBefore [ "i915" ]; # AMD: "amdgpu"

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
