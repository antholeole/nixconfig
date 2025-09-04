{
  inputs,
  pkgs,
  config,
  ...
}: {
  programs.firefox = {
    enable = !config.conf.work && !config.conf.headless;

    profiles.default = {
      id = 0;
      name = "dft";

      settings = {
        "extensions.autoDisableScopes" = 0;
        "devtools.toolbox.host" = "window";
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.start.page" = 3;
      };

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        bitwarden
        vimium
      ];
    };
  };
}
