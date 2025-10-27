{config, ...}: {
  conf = {
    wmStartupCommands = ["ssh-agent -a $SSH_AUTH_SOCK"];
    email = "luca.fondo@trai.ch";
    termColor = config.colorScheme.palette.base0E;
    name = "folu";
    work = true;
  };
}
