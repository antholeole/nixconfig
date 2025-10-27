{config, ...}: {
  conf = {
    email = "luca.fondo@trai.ch";
    name = "folu";
    selfAlias = "folu";

    termColor = config.colorScheme.palette.base0E;
    nixos = true;
    wm = true;

    headless = false;
    work = false;

    features = [
      "video-editing"
      "gaming"
      "kubectl"
    ];
  };
}
