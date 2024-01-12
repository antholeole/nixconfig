{ pkgs, inputs, sysConfig, lib, ... }:
let magic_key = "|";
in {
  services.espanso = lib.mkIf (!sysConfig.headless) {
    enable = true;

    package = with pkgs;
      let
        espanso2_21 = espanso-wayland.overrideAttrs (old: rec {
          version = "2.2.1";
          src = fetchFromGitHub {
            owner = "espanso";
            repo = "espanso";
            rev = "v${version}";
            hash = "sha256-5TUo5B1UZZARgTHbK2+520e3mGZkZ5tTez1qvZvMnxs=";
          };
        });
      in espanso2_21;

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
