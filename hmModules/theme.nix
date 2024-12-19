{
  inputs,
  lib,
  config,
  ...
}: let
  colors = inputs.nix-colors;
in {
  imports = [
    colors.homeManagerModules.default
  ];

  options.font = lib.options.mkOption {
    type = lib.types.string;
    default = "FiraCode Nerd Font";
  };

  # https://tinted-theming.github.io/base16-gallery/
  config = rec {
    colorScheme = colors.colorSchemes.gruvbox-dark-medium;
    home.file.".config/colors/scheme.scss" = {
      enable = !config.conf.headless;
      text = let
        makeScssVar = name: value: "\$${name}: #${value};\n";
        lines = lib.attrsets.mapAttrsToList makeScssVar colorScheme.palette;
      in
        lib.concatStrings lines;
    };
  };
}
