[
  # node
  "node_modules"

  # nix
  ".direnv"
  ".devenv"

  # lang / tool specific
  "output/" # tf (custom)
  ".terraform" # tf
  "*.tfstate*"
  ".metals/" # scala
  ".scala-build" # scala
  ".bloop/" # scala
  "?/" # honestly idk but it appears in scala dirs
  "bazel-*" # bazel
  ".sass-cache" # sass
  "*.class" # java / scala
  "target/" # java / scala

  "@girs/" # ags

  ".cache" # cmake
  "CMakeFiles" # cmake
  "_deps"

  ".pulumi/" # pulumi

  "*.out" # built

  # vcs
  ".jj"
  ".git"

  # other
  "__scratch"

  # python
  ".venv/"
  "venv/"
]
