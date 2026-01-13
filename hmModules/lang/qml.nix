{ pkgs, ... }: {
  home.packages = with pkgs; [
    kdePackages.qtdeclarative
  ];

  programs.helix.languages = {
    language-server = {
      qmlls = {
        name = "qmlls";
        command = "qmlls";
        args = ["-E"];
      };
    };
  };
}
