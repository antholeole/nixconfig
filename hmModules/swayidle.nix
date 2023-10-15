{ pkgs, lib, sysConfig, ... }: {
  services.swayidle = lib.mkIf (!sysConfig.headless) {
    enable = true;

    events = [{
      event = "before-sleep";
      command = "swaylock";
    }];
  };
}
