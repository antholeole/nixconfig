let default_conf = {
  name = "anthony";
  nixgl = null;
  bluetooth = true;
  fontSize = 18;
  headless = false;

  laptop = {
    brightnessDir = "gpio-bl";
    battery = "macsmc-battery";
    adapter = "macsmc-ac";
  };
}; in { 
  kayak-asahi = default_conf;

  hm-pc = default_conf // {
    laptop = null;
    bluetooth = false;
    nixgl = "Nvidia";
    fontSize = 10;
  };

  hm-work = default_conf // {
    name = "oleina";
    fontSize = 20;

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
  };
}
