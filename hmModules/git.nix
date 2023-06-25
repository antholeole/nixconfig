{ pkgs, ... }:
let
  nonixGitignoreFilename = ".nonix.gitignore";
in
{
  home.file."${nonixGitignoreFilename}".text = ''
    .direnv
    .envrc
    .direnv/
    flake.nix
    flake.lock
  '';

  programs.git = {
    enable = true;

    ignores = [
      "node_modules/"
      ".vscode"
    ];

    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      user.name = "Anthony Oleinik";
    };

    includes = [{
      condition = "gitdir:~/Work/";

      contents.core = {
        excludesFile = "~/.nonix.gitignore";
      };
    }];
  };
}
