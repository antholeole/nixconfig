{config, ...}: {
  conf = {
    email = "oleina@google.com";
    name = "oleina";
    homeDirPath = "/usr/local/google/home/";

    termColor = config.lib.stylix.colors.base0D;

    headless = true;
    work = true;

    features = [
      "kubectl"
    ];
  };
}
