{config, ...}: {
  conf = {
    wmStartupCommands = ["ssh-agent -a $SSH_AUTH_SOCK"];
    email = "oleina@google.com";
    termColor = config.lib.stylix.colors.base0E;
    name = "oleina";
    work = true;
  };
}
