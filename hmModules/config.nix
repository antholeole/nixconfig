{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
in {
  options.conf = mkOption {
    description = "configuration per nixos or home-manager devices I own";
    type = lib.types.submodule {
      options = with lib.types; {
        name = mkOption {
          type = str;
          default = "anthony";
          description = "your home directory name";
        };

        email = mkOption {
          type = str;
          default = "antholeinik@gmail.com";
          description = "email; used for git signoffs.";
        };

        headless = mkOption {
          type = bool;
          default = false;
          description = "if the device is headless.";
        };

        homeDirPath = mkOption {
          type = str;
          default = "/home/";
          description = "the path at which the home directory resides. this is different on corp machines.";
        };

        termColor = mkOption {
          type = str;
          default = config.colorScheme.palette.base0D;
          description = "the accent color on the terminal. I use this to visually be able to tell if I'm ssh'd or not.";
        };

        selfAlias = mkOption {
          type = str;
          default = "oleina";
          description = "your screen name; used for prefixing git branches in an easy way";
        };

        work = mkOption {
          type = bool;
          default = false;
          description = "if we are on a corp device or not. Some programs are not allowed on corp devices.";
        };

        wmStartupCommands = mkOption {
          type = listOf str;
          default = [];
          description = "commands ran at boot for the window manager. has no effect if headless.";
        };

        # TODO: move this into features
        wm = mkOption {
          type = bool;
          default = true;
          description = "if we should include a window manager or not. Some systems are running a DE so do not require the WM.";
        };

        nixos = mkOption {
          type = bool;
          default = false;
          description = "if this hmModule will be used on nixos.";
        };

        features = mkOption {
          type = listOf str;
          default = [];
          description = "";
        };
      };
    };
  };
}
