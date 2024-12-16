{
  nix-colors,
  lib,
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
  config.colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
}
