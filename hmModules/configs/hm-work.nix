{config, ...}: {
  conf = {
    wmStartupCommands = ["ssh-agent -a $SSH_AUTH_SOCK"];
    email = "oleina@google.com";
    termColor = config.colorScheme.palette.base0E;
    name = "oleina";
    work = true;
  };
}
