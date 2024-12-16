inputs:
with builtins; let
  mapAttrToPath = map (conf: "${inputs.self}/hmModules/${conf}");
  filterOut = filter (fileName: fileName != "default.nix" && fileName != "configs");

  files = readDir "${inputs.self}/hmModules";
  justFileNames = attrNames files;
in
  mapAttrToPath (filterOut justFileNames)
