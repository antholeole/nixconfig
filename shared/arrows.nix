# given a direction and a command, returns that command for both
# the vim keybinding and the direction.
{ lib, dir, commandFn, mkDir ? (dir: dir) }:
let
  dirs = {
    right = [ "l" (mkDir "right") ];
    left = [ "h" (mkDir "left") ];
    up = [ "k" (mkDir "up") ];
    down = [ "j" (mkDir "down") ];
  };
in lib.concatLines (builtins.map commandFn dirs."${dir}")
