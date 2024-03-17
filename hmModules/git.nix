{ inputs, pkgs, sysConfig, ... }:
let
  mkGitScript = script: {
    executable = true;
    source = "${inputs.self}/scripts/git/git-${script}";
  };
in {
  # top level
  home.file.".config/git/git-spinoff" = mkGitScript "spinoff";
  home.file.".config/git/git-wip" = mkGitScript "wip";
  home.file.".config/git/git-cleave" = mkGitScript "cleave";

  # deps
  home.file.".config/git/git-current-branch" = mkGitScript "current-branch";
  home.file.".config/git/git-is-clean" = mkGitScript "is-clean";
  home.file.".config/git/git-is-dirty" = mkGitScript "is-dirty";
  home.file.".config/git/git-root" = mkGitScript "root";

  programs.git = {
    enable = true;

    difftastic = { enable = true; };

    ignores = [ 
      "node_modules/" 
      ".vscode" 

      ".direnv/" 
      ".devenv/" 


      "**/__scratch/"
    ];

    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictStyle = "diff3";
      diff.algorithm = "histogram";

      core.editor = with pkgs; "${lib.getExe kakoune}";

      user = with sysConfig; { inherit email name; };
    };
  };
}
