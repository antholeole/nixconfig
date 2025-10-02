{config, ...}: {
  conf = {
    email = "antholeinik@gmail.com";
    name = "anthony";
    selfAlias = "oleina";
    homeDirPath = "/Users/";

    termColor = config.colorScheme.palette.base0E;

    nixos = false;
    wm = false;
    headless = false;
    work = false;
    darwin = true;

    features = [];
  };
}
