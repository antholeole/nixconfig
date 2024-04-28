pkgs:
let
  fs = pkgs.lib.fileset;

  remoteClip = pkgs.buildGoModule {
      vendorHash = "sha256-KMsYgkLRoQvxDJQvqC58zOyUlU2Kc1sx0s0EbDDGIVQ=";
      src = ./.;

      subPackages = [
        "rcserver"
        "rcclient"
      ];

      name = "remoteclip";
    };
in {
  server = remoteClip;
  client = let
    mkCommand = cmd: "${remoteClip}/bin/rcclient ${cmd}";
  in {
    copy = mkCommand "copy";
    paste = mkCommand "paste";
    done = mkCommand "done";
    cliphist = mkCommand "cliphist";
  };
}
