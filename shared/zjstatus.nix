pkgs: sysConfig:
let
  colors = import ../theme.nix;
  bgColor = colors.mantle;
  fgColor = sysConfig.termColor;
in ''
  pane size=1 borderless=true {
         plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
           format_space "#[bg=${bgColor}]"

           mode_normal  "#[bg=${fgColor},fg=${colors.base}] {name} "
           mode_locked  "#[bg=${colors.yellow},fg=${bgColor}] {name} "

           tab_normal   "#[fg=${fgColor}] {name} "
           tab_active   "#[fg=${bgColor},bg=${fgColor}] {name} "

           format_left  "{tabs}"
           format_right "#[fg=${fgColor},bg=${bgColor}] {session} {mode} "
         }
       }
''
