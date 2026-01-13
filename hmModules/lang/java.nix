{ pkgs, ... }: {
  home.packages = with pkgs; [
    metals
    coursier
  ];

  programs.helix.languages = {
    language-server = {
      # we aren't specifying JAVA_HOME; each project probably has its own.
      metals.command = "metals";
    };
  };
}
