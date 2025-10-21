{
  pkgs,
  lib,
  config,
  ...
}: let
  mkIfEnabled =
    lib.mkIf (builtins.elem "kubectl" config.conf.features);
in {
  home.packages = mkIfEnabled [
    pkgs.kubernetes-helm
  ];

  programs.fish.shellAbbrs = mkIfEnabled {
    k = "kubectl";
  };

  programs.kubecolor = mkIfEnabled {
    package = pkgs.symlinkJoin {
      pname = "kubecolor";
      name = "kubecolor";
      version = pkgs.kubecolor.version;

      paths = with pkgs; [
        kubectl
        kubecolor
        kubectl-explore
      ];

      meta.mainProgram = "kubecolor";
    };

    enable = true;
    enableAlias = true;
  };
}
