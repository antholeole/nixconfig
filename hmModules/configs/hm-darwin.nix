{config, ...}: {
  conf = {
    email = "antholeinik@gmail.com";
    name = "anthony";
    selfAlias = "oleina";
    homeDirPath = "/Users/";

    termColor = config.lib.stylix.colors.base0E;

    nixos = false;
    wm = false;
    headless = false;
    work = false;
    darwin = true;

    features = [];
  };
}
