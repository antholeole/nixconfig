let 
  mkFontSizes = fontSizes @ {
    defaultFontSize ? 18,
    glFontSize ? 10,
  }: fontSizes;

  default_conf = {
    name = "anthony";
    email = "antholeinik@gmail.com";
    nixgl = null;
    bluetooth = true;
    headless = false;
    keymap = "ctrl:swap_lwin_lctl";
    alsaSupport = true;
    homeDirPath = "/home/";

    fontSizes = mkFontSizes {};

    dailysh = {};

    laptop = {
      brightnessDir = "gpio-bl";
      battery = "macsmc-battery";
      adapter = "macsmc-ac";
    };
  }; 
in { 
  kayak-asahi = default_conf;

  hm-pc = default_conf // {
    laptop = null;
    alsaSupport = false;
    bluetooth = false;
    keymap = null;
    nixgl = "Nvidia";
    fontSize = 10;
  };

  hm-work = default_conf // {
    name = "oleina";
    email = "oleina@google.com";
    alsaSupport = false;
    keymap = "altwin:ctrl_alt_win";
    nixgl = "Default";
    dailysh = {
      gcert = "gcert";
    };

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

  hm-headless = default_conf // {
    name = "oleina";
    headless = true;
    bluetooth = false;
    homeDirPath = "/usr/local/google/home/";
  };
}
