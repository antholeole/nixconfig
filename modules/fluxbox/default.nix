{ pkgs, ... }: {
  home-manager.users.anthony = { lib, ... }: {
    xsession.windowManager.fluxbox = {
      enable = true;
      
      keys = builtins.readFile ./keys;
      apps = builtins.readFile ./apps;
      init = builtins.readFile ./init;
      startup = builtins.readFile ./startup;
    };

    home = {
      file."wall.png".source = ./bg.png; 

      activation = {
          symLinkStyles = lib.hm.dag.entryAfter ["writeBoundary"] ''
            $DRY_RUN_CMD ln -snf $VERBOSE_ARG \
              ${builtins.toPath ./styles} $HOME/.fluxbox/styles
          '';
      };
    };     
  };
}