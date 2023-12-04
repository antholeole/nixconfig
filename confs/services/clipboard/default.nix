pkgs: let 
    fs = pkgs.lib.fileset;

    remoteClipPkg = filterOut: let
        fileset = fs.fileFilter (file: file.name != filterOut) ./.;
    in pkgs.buildGoModule {
        src = fs.toSource {
            inherit fileset;

            root = ./.;
        };

        name = "remoteclipboard";
        vendorHash = "sha256-KMsYgkLRoQvxDJQvqC58zOyUlU2Kc1sx0s0EbDDGIVQ=";
    };
in {
    # this is confusing but its much simpler to specify the file 
    # that we don't want 
    server = remoteClipPkg "client.go";
    client = let 
        rcClient = remoteClipPkg "server.go";
    in {
        copy = "${rcClient}/bin/oleinaconf.com copy";
        paste = "${rcClient}/bin/oleinaconf.com paste";
        cliphist = "${rcClient}/bin/oleinaconf.com cliphist";
    };
}