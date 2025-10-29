{ pkgs, ... }: {
  # Enable Plymouth for a graphical boot splash screen
  boot.plymouth = {
    enable = true;
    theme = "rings"; # Example theme
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "rings" ];
      })
    ];
  };

  # Enable systemd in the initrd for a graphical LUKS password prompt
  boot.initrd.systemd.enable = true;

  # Optional: Configure for a silent boot experience
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [ "quiet" "splash" "boot.shell_on_fail" "udev.log_priority=3" "rd.systemd.show_status=auto" ];
}
