{ pkgs, mkWaylandElectronPkg, inputs, lib, sysConfig, ... }:
{
  programs.vscode = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = with pkgs.vscode; {
      inherit pname version;
    } // mkWaylandElectronPkg {
      pkg = pkgs.vscode;
      exeName = "code";
    };
    
    extensions = with pkgs.vscode-extensions;
      [
        # This is much better than the complex setup
        rust-lang.rust-analyzer
        scalameta.metals
        golang.go
        # gregoire.dance :(
        # tobias-z.vscode-harpoon :(
        catppuccin.catppuccin-vsc
        # catppuccin.catppuccin-vsc-icons
        yzhang.markdown-all-in-one
      ];

    keybindings = with builtins; fromJSON (readFile "${inputs.self}/confs/code/keybindings.json");
    userSettings = with builtins; fromJSON (readFile "${inputs.self}/confs/code/settings.json");
  };
}
