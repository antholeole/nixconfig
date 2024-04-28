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

  copy = "${remoteClip}/bin/rcclient copy";
  paste = "${remoteClip}/bin/rcclient paste";
  done = "${remoteClip}/bin/rcclient done";
  cliphist = "${remoteClip}/bin/rcclient cliphist";
}
