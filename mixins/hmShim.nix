{ pkgs, inputs, specialArgs, ... }:
let
  mkNixosModuleFromHmModule = hmModulePath: {
    home-manager = {
      extraSpecialArgs = specialArgs;
      useGlobalPkgs = true;

      users.anthony = hmModulePath;
    };
  };
in
{
  imports = map mkNixosModuleFromHmModule (import "${inputs.self}/hmModules" inputs);
}
