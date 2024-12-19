{
  nix-colors,
  lib,
  config,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  options.font = lib.options.mkOption {
    type = lib.types.string;
    default = "FiraCode Nerd Font";
  };

  # https://tinted-theming.github.io/base16-gallery/
  config = rec {
    colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
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
