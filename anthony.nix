{ pkgs, inputs, config, laptop, hidpi, ... }:
{
  fonts.fontconfig.enable = true;

  xsession = import "${inputs.self}/modules/xsession.nix" pkgs;

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services = {
    playerctld.enable = true;
    blueman-applet.enable = true;
    gnome-keyring.enable = true;
    unclutter.enable = true;

    polybar = import "${inputs.self}/modules/polybar.nix" { inherit pkgs laptop hidpi; };
    dunst = import "${inputs.self}/modules/dunst.nix";
    mpd = import "${inputs.self}/modules/mpd.nix";
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

    file."wall.png".source = let 
      bgName = (if laptop then "bg" else "bg_tall");
    in "${inputs.self}/images/${bgName}.png";

    packages = with pkgs; [
      pavucontrol
      mpc-cli # music 
      chromium #browser
      polydoro # polybar pomodoro timer
      shutter-save # screenshotter (activated thru fluxbox keys)
      slock # screen locker
      xorg.xbacklight # brightness
      gapp
      python3
      unzip
      dconf
      dunst
      libnotify
      glib # for notifications
      feh # for background
      fluxbox

      # language specific
      nixpkgs-fmt # we're gonna be writing a lot of nix :)
      rustup
      gcc # sad but this should be global so vscode can find it


      # fonts
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
      fira-code-symbols
    ] ++ (if pkgs.system == "x86_64-linux" then [ insomnia ] else [ postman ]);
  };

  programs = {
    keychain = {
      enable = true;
      enableXsessionIntegration = true;
    };

    direnv = {
      enableBashIntegration = true;
      enable = true;
    };

    home-manager.enable = true;
    ncmpcpp.enable = true;

    vscode = import "${inputs.self}/modules/code" pkgs.vscode-extensions;
    git = import "${inputs.self}/modules/git.nix" pkgs;

    rofi = import "${inputs.self}/modules/rofi.nix" { inherit config pkgs hidpi; };
    bash = import "${inputs.self}/modules/bash.nix" { inherit inputs pkgs; };

    starship = import "${inputs.self}/modules/starship.nix";
    alacritty = import "${inputs.self}/modules/alacritty.nix" hidpi;
  };

  home.stateVersion = "23.05";
}
