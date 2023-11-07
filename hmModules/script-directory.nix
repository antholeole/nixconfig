{ pkgs, config, ... }: {
  programs.script-directory = {
    enable = true;
    settings = {
      SD_EDITOR = pkgs.lib.getExe' config.programs.kakoune.package "kak";
    };
  };
}