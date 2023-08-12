{ pkgs, inputs, ... }:
{
  programs.kakoune = {
    enable = true;

    #config = {
    #  hooks = [{
    #    name = "RegisterModified";
    #    commands =  "printf %s \"$kak_main_reg_dquote\" | ${pkgs.wl-clipboard}/bin/wl-copy > /dev/null 2>&1 &";
    #   }];
    #};
  };
}
