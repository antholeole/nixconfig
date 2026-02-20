{pkgs, ...}: {
  home.packages = with pkgs; [
    gopls
    go
  ];

  programs.helix.languages.language-server.gopls = {
    command = "gopls";
    "build.workspaceFiles" = ["**/BUILD" "**/WORKSPACE" "**/*.{bzlbazel}"];
    "build.directoryFilters" = [
      "-bazel-bin"
      "-bazel-out"
      "-bazel-testlogs"
      "-bazel-mypkg"
    ];
    "formatting.gofumpt" = true;
    "formatting.local" = "github.com/my/mypkg";
    "ui.completion.usePlaceholders" = true;
    "ui.semanticTokens" = true;
    "ui.codelenses" = {
      gc_details = false;
      generate = false;
      regenerate_cgo = false;
      test = false;
      tidy = false;
      upgrade_dependency = false;
      vendor = false;
    };
  };
}
