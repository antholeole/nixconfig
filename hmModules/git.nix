{ pkgs, sysConfig, ... }:
let
  nonixGitignoreFilename = ".nonix.gitignore";
in
{
  home.file."${nonixGitignoreFilename}".text = ''
    .direnv/
    .envrc
    flake.nix
    flake.lock
    .devenv/
  '';

  programs.git = {
    enable = true;

    difftastic = {
      enable = true;
    };

    ignores = [
      "node_modules/"
      ".vscode"
      ".direnv/"
    ];

    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      core.editor = with pkgs; "${lib.getExe kakoune}";

      user = with sysConfig; {
        inherit email name;
      };
    };

    includes = [{
      condition = "gitdir:~/Work/";

      contents.core = {
        excludesFile = "~/.nonix.gitignore";
      };
    }];
  };
}
