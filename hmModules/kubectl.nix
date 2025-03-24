{pkgs,...}: {
  home.packages = [
    pkgs.kubectl-explore
  ];
  
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
}
