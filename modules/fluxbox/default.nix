{
  enable = true;

  keys = builtins.readFile ./keys;
  apps = builtins.readFile ./apps;
  init = builtins.readFile ./init;
  startup = builtins.readFile ./startup;
  styles = ./styles;
}
