{config, ...}: {
  conf = {
    email = "luca.fondo@trai.ch";
    name = "folu";
    homeDirPath = "/Users/";

    termColor = config.colorScheme.palette.base0D;

    headless = true;
    work = true;

    features = [
      "kubectl"
    ];
  };
}
