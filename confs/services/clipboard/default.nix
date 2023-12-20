pkgs:
let
  remoteClipPkg = path: vendorHash: pkgs.buildGoModule {
      vendorHash = "sha256-eDSdZpN51IlQ6TcikkBF0BprOmkjp3+mY5A5VC37RDU=";

      modRoot = ./.;
      src = ./.;
      
      pname = "oleinaconf.com";
      name = "oleinaconf.com";
    };
in {
  server = remoteClipPkg "server" "";
  client = let
    rcClient = remoteClipPkg "client" pkgs.lib.fakeHash;
  in {
    copy = "${remoteClipPkg}/bin/oleinaconf.com copy";
    paste = "${remoteClipPkg}/bin/oleinaconf.com paste";
    cliphist = "${remoteClipPkg}/bin/oleinaconf.com cliphist";
    done = "${remoteClipPkg}/bin/oleinaconf.com done";
  };
}
