{
  inputs,
  pkgs,
  sysConfig,
  ...
}: let
  mkGitScript = script: {
    executable = true;
    source = "${inputs.self}/scripts/git/git-${script}";
  };
in {
  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options = {
        syntax-theme = "catppuccin-macchiato";
        line-numbers = true;
        side-by-side = true;
      };
    };

    # TODO: do I need to add a / to the end?
    ignores = import "${inputs.self}/shared/ignores.nix";

    aliases = {
      # just gerrit things
      cl = "!f() { git push origin HEAD:refs/for/\${1:-master}; }; f";

      # list all the conflicts
      conflicts = "diff --name-only --diff-filter=U";
    };

    extraConfig = {
      # sad but this doesn't work with repos that don't have it
      # blame.ignoreRevsFile = ".git-blame-ignore-revs";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      diff.algorithm = "histogram";

      core.editor = with pkgs; "${lib.getExe kakoune}";

      user = with sysConfig; {inherit email name;};
    };
  };
}
