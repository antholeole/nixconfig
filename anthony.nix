{ config, pkgs, inputs, ... }:
{
  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
      ];
    })
    fira-code-symbols
  ];

  home-manager.users.anthony = { lib, ... }: {
    fonts.fontconfig.enable = true;

    xsession.enable = true;

    services = {
      playerctld.enable = true;
      blueman-applet.enable = true;
      gnome-keyring.enable = true;
      unclutter.enable = true;


      dunst = import "${inputs.self}/modules/dunst.nix";

      mopidy = {
        enable = true;

        extensionPackages = with pkgs; [ mopidy-mpris ];

        settings = {
          files = {
            media_dirs = [
              "$XDG_MUSIC_DIR|Music"
              "~/Music"
            ];
          };
        };
      };
    };


    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Frappe-Standard-Flamingo-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "flamingo" ];
          size = "standard";
          tweaks = [ "rimless" ];
          variant = "frappe";
        };
      };
    };

    home = {
      username = "anthony";
      homeDirectory = "/home/anthony";

      file."Scripts/alias.sh".text = "alias | awk -F'[ =]' '{print $2}'";

      packages = with pkgs; [
        chromium #browser
        mopidy # audio
        playerctl # audio
        polydoro # polybar pomodoro timer
        shutter # screenshotter (activated thru fluxbox keys)
        postman # REST client (swap with insomnia when we finally can!)
        slock # screen locker
        xorg.xbacklight # brightness
        python3
        unzip
        dconf
        dunst libnotify glib # for notifications
        feh # for background

        # language specific
        nixpkgs-fmt # we're gonna be writing a lot of nix :)
        rustup gcc # sad but this should be global so vscode can find it
      ];
    };

    programs = {
      keychain = {
        enable = true;
        enableXsessionIntegration = true;
      };

      bash = {
        enable = true;

        shellAliases = import "${inputs.self}/modules/terminal_aliases.nix" pkgs;

        bashrcExtra = ''
          eval "$(starship init bash)";
          function cdc { mkdir -p $1 && cd $1; };
        '';
      };

      # rofi?
      # wlsunset
      # https://discourse.nixos.org/t/setting-caps-lock-as-ctrl-not-working/11952/3 

      direnv = {
        enableBashIntegration = true;
        enable = true;
      };
    };

    home.stateVersion = "20.03";
  };
}
