{ inputs, pkgs, sysConfig, ... }:
let
  mkGitScript = script: {
    executable = true;
    source = "${inputs.self}/scripts/git/git-${script}";
  };
in {
  programs.git = {
    enable = true;

    delta = {
        enable = true;
    };


    ignores = import "${inputs.self}/shared/ignores.nix";

    aliases = {
      # just gerrit things
      cl = "!f() { git push origin HEAD:refs/for/\${1:-master}; }; f";

      # list all the conflicts
      conflicts = "diff --name-only --diff-filter=U";
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
