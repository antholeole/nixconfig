{ pkgs, ... }: {
  home-manager.users.anthony = { lib, ... }: {
    xsession.windowManager.fluxbox = {
      enable = true;
      
      keys = builtins.readFile ./keys;
      startup = builtins.readFile ./startup;
      apps = builtins.readFile ./apps;
      init = builtins.readFile ./init;
    };

    home = {
      file."wall.png".source = ./bg.png; 
      file.".fluxbox/overlay".source = ./overlay;

      activation = {
          symLinkStyles = lib.hm.dag.entryAfter ["writeBoundary"] ''
            $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
              ${builtins.toPath ./styles} $HOME/.fluxbox/styles
          '';
      };
    };     
  };
}