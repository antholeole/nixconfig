let default_conf = {
  name = "anthony";
  nixgl = null;
  bluetooth = true;
  fontSize = 18;
  headless = false;
  keymap = "ctrl:swap_lwin_lctl";
  alsaSupport = true;
  homeDirPath = "/home/";

  laptop = {
    brightnessDir = "gpio-bl";
    battery = "macsmc-battery";
    adapter = "macsmc-ac";
  };
}; in { 
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
    fontSize = 20;
    alsaSupport = false;
    keymap = "altwin:ctrl_alt_win";

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
