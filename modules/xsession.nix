{ pkgs, ... }: {
    home-manager.users.anthony = {
      xsession = {
        enable = true;
      };
    };
}
