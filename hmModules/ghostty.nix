{pkgs-unstable, config, lib, ...}: {
  programs.ghostty = lib.mkIf (!config.conf.headless) {
    enable = true;
    enableFishIntegration = true;

    package = pkgs-unstable.ghostty;

    settings = {
      theme = "GitHub Dark Default";
      font-size = 10;
      font-family = "Monaspace Neon";
      mouse-hide-while-typing = true;
      shell-integration = "fish";
      command = "${config.programs.fish.package}/bin/fish";
      keybind = "global:cmd+grave_accent=toggle_quick_terminal";
      quick-terminal-position = "center";
      quick-terminal-size = "60%,40%";
    };
  };
}
