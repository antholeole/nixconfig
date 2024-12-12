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
      godbolt = "godbolt.org";
      kubespec = "kubespec.dev";
    };

    searchEngines = {
      g = "https://www.google.com/search?hl=en&q={}";
      cpp = "https://duckduckgo.com/?sites=cppreference.com&q={}&ia=web";
    };
  };
}
