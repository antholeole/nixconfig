pkgs: {
  pkg, exeName ? null
}: with pkgs; let 
  pname = pkg.pname;
in pkgs.symlinkJoin {
  name = pname;
  paths = [ pkg ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/${if exeName != null then exeName else pname} \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
  '';
}
