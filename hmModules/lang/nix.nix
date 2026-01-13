{ pkgs, ... }: {
  home.packages = with pkgs; [
    alejandra
    nil
  ];

  programs.helix.languages = {
    language-server = {
      nil = {
        command = "nil";
        config.nil.formatting.command = ["alejandra" "-q"];
      };
    };
  };
}
