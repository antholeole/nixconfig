{config, ...}: {
  config = {
    wmStartupCommands = ["ssh-agent -a $SSH_AUTH_SOCK"];
    email = "oleina@google.com";
    name = "oleina";

    termColor = config.colorScheme.palette.base0C;

    headless = true;
    work = true;
  };
}
