{ pkgs, inputs, sysConfig, lib, ... }:
let
  magic_key = "|";
in
{
  services.espanso = lib.mkIf (!sysConfig.headless) {
    enable = true;

    package = with pkgs; pkgs.symlinkJoin {
      name = "espanso";
      paths = [ espanso-wayland wl-clipboard ];
      buildInputs = [ makeWrapper ];
      version = espanso-wayland.version;
      postBuild = ''
        wrapProgram $out/bin/espanso --set PATH ${lib.makeBinPath [
          "/usr/bin/"
          wl-clipboard
        ]}
      '';
    };

    configs.default = {
      toggle_key = "ALT";
      search_shortcut = "ALT+O";
      pre_paste_delay = 100;
      evdev_modifier_delay = 5;
    };

    matches.base = {
      matches =
        let
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
            "sr" = "server";
            "rv" = "review";
            "tf" = "traffic";
            "rz" = "reason";
            "xp" = "expire";
            "ud" = "update";
            "rm" = "remove";
            "mn" = "manage";
            "th" = "thought";
            "me" = "Anthony";
            "who" = "whoever";
            "svc" = "service";
            "po" = "possible";
            "svr" = "server";
            "cfg" = "configuration";
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
            "call" = "Can we hop on a call real quick";
          };
        in
        with lib; attrsets.mapAttrsToList (
          replacment: value: (mkMagicReplace replacment value)
        ) replacements;
    };
  };
}
