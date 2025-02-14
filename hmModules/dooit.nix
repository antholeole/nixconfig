{pkgs, ...}: {
  # TODO upsteam a change to make the package overrideable
  home.packages = [pkgs.dooit];
}
