pkgs: let
  remoteClip = pkgs.buildGoModule {
    vendorHash = "sha256-KMsYgkLRoQvxDJQvqC58zOyUlU2Kc1sx0s0EbDDGIVQ=";
    src = ./.;

    subPackages = ["rcserver" "rcclient"];

    name = "remoteclip";
  };
in {
  server = remoteClip;
  client = let
    mkCommand = cmd: "${remoteClip}/bin/rcclient ${cmd}";
  in {
    package = "${remoteClip}/bin/rcclient";
    copy = mkCommand "copy";
    paste = mkCommand "paste";
    notify = mkCommand "notify";
  };
}
