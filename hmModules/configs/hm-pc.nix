{config, ...}: {
  conf = {
    email = "antholeinik@gmail.com";
    name = "anthony";
    selfAlias = "oleina";

    termColor = config.lib.stylix.colors.base0E;
    nixos = true;
    wm = true;

    headless = false;
    work = false;

    features = [
      "video-editing"
      "gaming"
      "kubectl"
      "minecraft"
    ];
  };
}
