# This module extends home.file with the `mutable` option.
# It is really useful when programs, such as vscode, need writable configuration files.
# Strongly inspired by: https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
{
  config,
  lib,
  ...
}: let
  fileOptionAttrPaths = [["home" "file"]];
in {
  options = let
    mergeAttrsList = builtins.foldl' (lib.mergeAttrs) {};
    fileAttrsType = lib.types.attrsOf (lib.types.submodule ({config, ...}: {
      options.mutable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to copy the file without the read-only attribute instead of
          symlinking. If you set this to `true`, you must also set `force` to
          `true`. Mutable files are not removed when you remove them from your
          configuration.

          This option is useful for programs that don't have a very good
          support for read-only configurations.
        '';
      };
    }));
  in
    mergeAttrsList (map (attrPath:
      lib.setAttrByPath attrPath (lib.mkOption {type = fileAttrsType;}))
    fileOptionAttrPaths);

  config = {
    home.activation.mutableFileGeneration = let
      allFiles = builtins.concatLists (map
        (attrPath: builtins.attrValues (lib.getAttrFromPath attrPath config))
        fileOptionAttrPaths);

      filterMutableFiles = builtins.filter (file:
        (file.mutable or false)
        && lib.assertMsg file.force
        "if you specify `mutable` to `true` on a file, you must also set `force` to `true`");

      mutableFiles = filterMutableFiles allFiles;

      toCommand = file: let
        source = lib.escapeShellArg file.source;
        target = lib.escapeShellArg file.target;
      in ''
        $VERBOSE_ECHO "${source} -> ${target}"
        $DRY_RUN_CMD cp --remove-destination --no-preserve=mode ${source} ${target}
      '';

      command =
        ''
          echo "Copying mutable home files for $HOME"
        ''
        + lib.concatLines (map toCommand mutableFiles);
    in (lib.hm.dag.entryAfter ["linkGeneration"] command);
  };
}
