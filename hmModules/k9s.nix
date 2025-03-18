{inputs, ...}: let
  gruvbox-dark-medium = "gruvbox-dark-medium";
in {
  home.file.".config/k9s/skins/${gruvbox-dark-medium}" = {
    enable = true;
    source = "${inputs.self}/confs/k9s/gruvbox-dark-medium.yaml";
  };

  programs.k9s = {
    enable = true;

    settings.k9s = {
      skin = "gruvbox-dark-medium";

      ui = {
        headless = true;
        logoless = true;
      };

      skipLatestRevCheck = true;
    };
  };
}
