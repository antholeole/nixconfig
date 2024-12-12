{pkgs, ...}: {
  programs.qutebrowser = {
    quickmarks = {
      nixpkgs = "https://github.com/NixOS/nixpkgs";
      home-manager = "https://github.com/nix-community/home-manager";
    };

    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      g = "https://www.google.com/search?hl=en&q={}";
    };
  };
}
