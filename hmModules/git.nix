{ inputs, pkgs, sysConfig, ... }:
let
  mkGitScript = script: {
    executable = true;
    source = "${inputs.self}/scripts/git/git-${script}";
  };
in {
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

    aliases = {
        # just gerrit things
        cl = "!f() { git push origin HEAD:refs/for/\$\{1:-master}; }; f";
    };

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
