{...}: {
  programs.niri.enable = true;

  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };
  #services.desktopManager.plasma6.enable = true;
}
