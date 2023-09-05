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
    matches = let 
      mkMagicReplace = trigger: replace: {
        inherit replace;
        trigger = "${trigger}${magic_key}";
      };
    in [
      # TODO this could be { "trigger": "replace", "trigger": ["replace1" "replace2"]}
      (mkMagicReplace "st" "something")
      (mkMagicReplace "oj" "object")
      (mkMagicReplace "sh" "should")
      (mkMagicReplace "bt" "between")
      (mkMagicReplace "so" "someone")
      (mkMagicReplace "b4" "before")
      (mkMagicReplace "sr" "server")
      (mkMagicReplace "rv" "review")
      (mkMagicReplace "tf" "traffic")
      (mkMagicReplace "rz" "reason")
      (mkMagicReplace "xp" "expire")
      (mkMagicReplace "ud" "update")
      (mkMagicReplace "rm" "remove")
      (mkMagicReplace "mn" "manage")
      (mkMagicReplace "th" "thought")
      (mkMagicReplace "me" "Anthony")
      (mkMagicReplace "who" "whoever")
      (mkMagicReplace "svc" "service")
      (mkMagicReplace "po" "possible")
      (mkMagicReplace "svr" "server")
      (mkMagicReplace "cfg" "configuration")
      (mkMagicReplace "plz" "please")
      (mkMagicReplace "qu" "question")
      (mkMagicReplace "cl" "calendar")
      (mkMagicReplace "tg" "together")
      (mkMagicReplace "sp" "specific")
      (mkMagicReplace "sg" "sounds good")

      (mkMagicReplace "call" "Can we hop on a call real quick")
    ];
  };
};
}
