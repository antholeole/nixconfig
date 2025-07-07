{...}: {
  conf = {
    email = "antholeinik@gmail.com";
    name = "anthony";
    selfAlias = "oleina";

    nixos = true;
    wm = true;

    headless = false;
    work = false;

    features = [
      "video-editing"
      "gaming"
    ];
  };
}
