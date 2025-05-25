{
  inputs,
  config,
  lib,
  ...
}: {
  nixGL.packages = lib.mkIf (!config.conf.nixos) inputs.nixGL.packages;
}
