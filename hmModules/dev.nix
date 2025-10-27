{pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    fd # a faster find
    httpie # a simpler curl
    unzip
    jq
    yq
    repgrep # find replace
    bottom # top but nicer
    watchexec # code agnostic file watcher. very helpful for dev setups
    parallel # xargs but I like it better
    tldr
    babelfish
    rclone # very useful for remote stuff
    direnv # vsc ext checks path for this
    neofetch # for funzies
    arp-scan
    gawk
    gron # greppable json
    aspell
    aspellDicts.en
    delta # diffing
    pkgs-unstable.gemini-cli

    (writeShellScriptBin "bazel" ''
      ${bazelisk}/bin/bazelisk "$@"
    '')
  ];
}
