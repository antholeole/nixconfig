{pkgs,...}: {
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
  ];

  programs.steam.enable = true;
}
