{ pkgs, inputs, sysConfig, lib, ... }:
let magic_key = "|";
in {
  services.espanso = lib.mkIf (!sysConfig.headless) {
    enable = true;

    package = with pkgs;
      pkgs.symlinkJoin {
        name = "espanso";
        paths = [ espanso-wayland wl-clipboard ];
        buildInputs = [ makeWrapper ];
        version = espanso-wayland.version;
        #TODO this doesn't work and it spams journalctl with "cannot find gsettings"
        postBuild = ''
          wrapProgram $out/bin/espanso --set PATH ${
            lib.makeBinPath [ "/usr/bin/" "${glib.out}/" wl-clipboard ]
          }
        '';
      };

    configs.default = {
      toggle_key = "ALT";
      search_shortcut = "ALT+O";
      keyboard_layout = { layout = "us"; };
      pre_paste_delay = 100;
      evdev_modifier_delay = 5;
    };

    matches.base = {
      matches = let
        mkMagicReplace = trigger: replace: {
          inherit replace;
          trigger = "${trigger}${magic_key}";
        };

        replacements = {
          "st" = "something";
          "oj" = "object";
          "sh" = "should";
          "bt" = "between";
          "so" = "someone";
          "b4" = "before";
          "%" = "percent";
          "sv" = "server";
          "tal" = "take a look";
          "rz" = "reason";
          "xp" = "expire";
          "ud" = "update";
          "rm" = "remove";
          "mn" = "manage";
          "th" = "thought";
          "rq" = "request";
          "me" = "Anthony";
          "who" = "whoever";
          "sc" = "service";
          "po" = "possible";
          "cfg" = "configuration";
          "nw" = "no worries";
          "tyt" = "take your time";
          "plz" = "please";
          "qu" = "question";
          "cl" = "calendar";
          "tg" = "together";
          "sp" = "specific";
          "sg" = "sounds good";
          "rs" = "rubber stamp";
          "dp" = "deploy";
          "hn" = "hostname";
          "pr" = "provision";
          "dyt" = "do you think";
          "ps" = "persist";
          "imo" = "in my opinion";
          "sw" = "somewhere";
          "call" = "Can we hop on a call real quick";
        };
      in with lib;
      attrsets.mapAttrsToList
      (replacment: value: (mkMagicReplace replacment value)) replacements;
    };
  };
}
