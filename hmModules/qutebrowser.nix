{
  pkgs,
  sysConfig,
  ...
}: {
  programs.qutebrowser = {
    enable = !sysConfig.headless;

    quickmarks = {
      nixpkgs = "https://search.nixos.org";
      home-manager = "https://nix-community.github.io";
      qute = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
    };

    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      g = "https://www.google.com/search?hl=en&q={}";
    };
  };
}
