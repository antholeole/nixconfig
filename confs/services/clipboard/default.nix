pkgs: let 
    fs = pkgs.lib.fileset;

    remoteClipPkg = filterOut: let
        src = fs.fileFilter (file: file.Name != filterOut) ./.;
    in pkgs.buildGoModule {
        inherit src;

        name = "remoteclipboard";
        vendorSha256 = "sha256-KMsYgkLRoQvxDJQvqC58zOyUlU2Kc1sx0s0EbDDGIVQ=";
    };
in {
    server = remoteClipPkg "client.go";
    client = {

    };
}