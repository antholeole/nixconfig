{config, ...}: {
  conf = {
    email = "luca.fondo@trai.ch";
    name = "folu";
    selfAlias = "folu";
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
