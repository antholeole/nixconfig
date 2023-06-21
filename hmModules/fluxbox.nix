{ inputs, sysConfig, ... }: {
  xsession.windowManager.fluxbox = with builtins; listToAttrs
    (
      map
        (fbConfName: {
          name = fbConfName;
          value = (
            if fbConfName == "styles"
            then a: a
            else readFile
          ) "${inputs.self}/confs/fluxbox/${fbConfName}";
        })
        [ "enable" "keys" "init" "startup" "styles" ]
    ) // {
    enable = true;
  };

  # TODO: maybe move?
  home = {
    file."wall.png".source =
      let
        bgName = (if sysConfig.laptop then "bg" else "bg_tall");
      in
      "${inputs.self}/images/${bgName}.png";
  };
}
