{ lib, config, sysConfig, ... }: {
  programs.jujutsu = {
    enable = true;

    settings = {
      user = with sysConfig; { inherit email name; };
      ui.editor = "${config.programs.kakoune.package}/bin/kak";

      signing = {
        sign-all = true;
        key = "~/.ssh/id_ed25519.pub";
      };

      git = { push-branch-prefix = "${sysConfig.selfAlias}/"; };
    };

  };

  programs.fish.shellAbbrs = let
    wantsRevFlag = {
      jjst = "jj status";
      jja = "jj amend";
      jjd = "jj diff";
      jjlo = "jj log";
    };
    
    withRevFlag = (lib.attrsets.concatMapAttrs (abbr: command: {
      "${abbr}r" = {
        expansion = "${command} -r \"%\"";
        setCursor = true;
      };
    }) wantsRevFlag);

    noRevFlag = {
      jjn = "jj new";
      jjcb = {
        expansion = "jj branch create \"%\" -r @-";
        setCursor = true;
      };
      jjgp = "jj git push -c @-";
    };
  in wantsRevFlag // noRevFlag // withRevFlag;
}