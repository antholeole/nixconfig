let
  mkFontSizes = { defaultFontSize ? 18, glFontSize ? 10, }@fontSizes: fontSizes;

  default_conf = {
    name = "anthony";
    email = "antholeinik@gmail.com";
    bluetooth = true;
    headless = false;
    keymap = "ctrl:swap_lwin_lctl";
    alsaSupport = true;
    homeDirPath = "/home/";

    fontSizes = mkFontSizes { };

    wofiCmds = { };
    dailysh = { };
    wmStartupCommands = [ ];

    laptop = {
      brightnessDir = "gpio-bl";
      battery = "macsmc-battery";
      adapter = "macsmc-ac";
    };
  };
in rec {
  kayak-asahi = default_conf;

  hm-pc = default_conf // {
    laptop = null;
    alsaSupport = false;
    bluetooth = false;
    keymap = null;

    fontSizes = mkFontSizes {
      defaultFontSize = 20;
      glFontSize = 10;
    };
  };

  hm-work = default_conf // {
    name = "oleina";
    email = "oleina@google.com";
    alsaSupport = false;
    keymap = "altwin:ctrl_alt_win";

    wofiCmds = { chrome = "/bin/google-chrome"; };
    dailysh = { gcert = "gcert"; };

    wmStartupCommands = [ "ssh-agent -a $SSH_AUTH_SOCK" ];

    fontSizes = mkFontSizes {
      defaultFontSize = 20;
      glFontSize = 10;
    };

    laptop = {
      brightnessDir = "intel_backlight";
      battery = "BAT0";
      adapter = "AC";
    };
  };

  hm-headless-work = default_conf // {
    name = "oleina";
    headless = true;
    bluetooth = false;
    homeDirPath = "/usr/local/google/home/";
  };

  hm-headless = default_conf // { headless = true; };

  hm-headless-gce = default_conf // {
    headless = true;
    name = "oleina_google_com";
  };
}
