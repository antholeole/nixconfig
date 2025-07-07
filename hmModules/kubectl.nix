{pkgs, ...}: {
  programs.fish.shellAbbrs = {
    k = "kubectl";
  };

  programs.kubecolor = {
    package = pkgs.symlinkJoin {
      name = "kubecolor";
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
