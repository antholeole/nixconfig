{
  pkgs,
  config,
  ...
}: {
  programs.qutebrowser = {
    enable = !config.conf.headless;

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
      nix = "https://search.nixos.org/packages?channel=24.11&from=0&size=50&sort=relevance&type=packages&query={}";
      r = "https://www.reddit.com/search/?q={}";
    };
  };
}
