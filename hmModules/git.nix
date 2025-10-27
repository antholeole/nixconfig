{
  inputs,
  config,
  ...
}: {
  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = true;
      };
    };

    ignores = import ../shared/ignores.nix;

    aliases = {
      cl = "!f() { git push origin HEAD:refs/for/\${1:-master}; }; f";
    };

    extraConfig = {
      # sad but this doesn't work with repos that don't have it
      # blame.ignoreRevsFile = ".git-blame-ignore-revs";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      diff.algorithm = "histogram";

      core.editor = "${config.programs.helix.package}/bin/hx";

      user = with config.conf; {inherit email name;};
    };
  };
}
