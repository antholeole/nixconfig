{config, ...}: {
  conf = {
    wmStartupCommands = ["ssh-agent -a $SSH_AUTH_SOCK"];
    email = "oleina@google.com";
    name = "oleina";
    work = true;
  };
}
