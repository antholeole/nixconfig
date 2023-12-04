pkgs: let 
    fs = pkgs.lib.fileset;

    remoteClipPkg = filterOut: vendorHash: let
        fileset = fs.fileFilter (file: file.name != filterOut) ./.;
    in pkgs.buildGoModule {
        inherit vendorHash;
        src = fs.toSource {
            inherit fileset;

            root = ./.;
        };

        name = "remoteclipboard";
    };
in {
    # this is confusing but its much simpler to specify the file 
    # that we don't want 
    server = remoteClipPkg "client.go" "sha256-KMsYgkLRoQvxDJQvqC58zOyUlU2Kc1sx0s0EbDDGIVQ=";
    client = let 
        rcClient = remoteClipPkg "server.go" "sha256-eDSdZpN51IlQ6TcikkBF0BprOmkjp3+mY5A5VC37RDU=";
    in {
        copy = "${rcClient}/bin/oleinaconf.com copy";
        paste = "${rcClient}/bin/oleinaconf.com paste";
        cliphist = "${rcClient}/bin/oleinaconf.com cliphist";
    };
}