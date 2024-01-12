{ inputs, pkgs, sysConfig, ... }:
let
  mkGitScript = script: {
    executable = true;
    source = "${inputs.self}/scripts/git/git-${script}";
  };
in {
  home.file.".config/git/git-spinoff" = mkGitScript "spinoff";
  home.file.".config/git/git-wip" = mkGitScript "wip";
  home.file.".config/git/git-cleave" = mkGitScript "cleave";
  home.file.".config/git/git-is-clean" = mkGitScript "is-clean";
  home.file.".config/git/git-is-dirty" = mkGitScript "is-dirty";
  home.file.".config/git/git-root" = mkGitScript "root";

  programs.git = {
    enable = true;

    difftastic = { enable = true; };

    ignores = [ "node_modules/" ".vscode" ".direnv/" ];

    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;

      core.editor = with pkgs; "${lib.getExe kakoune}";

      user = with sysConfig; { inherit email name; };
    };
  };
}
