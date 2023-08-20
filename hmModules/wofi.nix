{ config, pkgs, lib, sysConfig, ... }:
let
  colors = import ../theme.nix;
in
{
  programs.wofi = lib.mkIf (!sysConfig.headless) {
    enable = true;

    style = with colors; ''
      /* Macchiato Flamingo */
      @define-color accent ${flamingo};
      @define-color txt ${text};
      @define-color bg ${base};
      @define-color bg2 ${surface2};

       * {
          font-family: '${font}', monospace;
          font-size: 14px;
          color: ${text};
       }

       window {
          margin: 1px;
          border: 1px solid @accent;
          background-color: @bg;
       }

       /* Outer Box */
       #outer-box {
          margin: 1px;
          border: none;
          background-color: @bg;
       }

       /* Scroll */
       #scroll {
          margin: 0px;
          padding: 10px;
          border: none;
       }

       /* Input */
       #input {
          border: none;
          border-radius: 0;
          margin: 3px;
          color: ${text};
          background-color: @bg2;
       }

       /* Text */
       #text {
          border: none;
          color: @txt;
       }

       #entry {
        margin: 2px;
        color: ${text};
       }

       /* Selected Entry */
       #entry:selected {
         background-color: @accent;
       }

       #entry:selected #text {
          color: @bg;
       }'';
      };
  }
