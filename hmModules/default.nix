with builtins; let
  mapAttrToPath = map (conf: ./${conf});
  filterOut = filter (fileName: fileName != "default.nix" && fileName != "configs");
  files = readDir ./.;
  justFileNames = attrNames files;
in
  mapAttrToPath (filterOut justFileNames)
