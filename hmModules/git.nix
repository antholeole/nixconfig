{
  inputs,
  config,
  ...
}: {
  programs.git = {
    enable = true;

    ignores = import ../shared/ignores.nix;

    settings = {
      # sad but this doesn't work with repos that don't have it
      # blame.ignoreRevsFile = ".git-blame-ignore-revs";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      diff.algorithm = "histogram";

      core.editor = "${config.programs.helix.package}/bin/hx";

      user = with config.conf; {inherit email name;};

      alias = {
        cl = "!f() { git push origin HEAD:refs/for/\${1:-master}; }; f";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
    };
  };
}
