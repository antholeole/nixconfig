inputs:
with builtins;
  (map (conf: "${inputs.self}/hmModules/${conf}"))
  ((filter (fileName: fileName != "default.nix"))
    (attrNames (readDir "${inputs.self}/hmModules")))
