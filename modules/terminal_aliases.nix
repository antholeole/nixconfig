{ pkgs, ... }: let
  mkChromeApp = siteName: "${pkgs.chromium.outPath}/bin/chromium --new-window --app=https://${siteName}.com";
in {
  mail = mkChromeApp "gmail";
  jamboard = mkChromeApp "jamboard.google";
  docs = mkChromeApp "docs.google";
  bard = mkChromeApp "bard.google";
  slides = mkChromeApp "slides.google";
}