{ pkgs, mkWaylandElectronPkg, mkOldNixPkg, inputs, lib, sysConfig, ... }: {
  programs.vscode = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = let
    	# this vscode version seems to work on Wayland.
    	# TODO: figure out why later ones don't
    	vscode_1_81 = (mkOldNixPkg {
		pkgsetHash = "50a7139fbd1acd4a3d4cfa695e694c529dd26f3a";
		pkgSha = lib.fakeSha256;
    	}).vscode;

	details = with vscode_1_81; {
    		inherit pname version;
	};

	waylandWrapped = mkWaylandElectronPkg {
    		pkg = vscode_1_81;
    		exeName = "code";
	};

	finalCode = details // waylandWrapped;
    in finalCode;

    extensions = with pkgs.vscode-extensions; [
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
    keybindings = with builtins;
      fromJSON (readFile "${inputs.self}/confs/code/keybindings.json") ++ [ ]
      ++ lib.lists.flatten (map (nInt:
        let n = toString nInt;
        in [
          {
            command = "-workbench.action.openEditorAtIndex${n}";
            key = "alt+${n}";
          }
          {
            key = "ctrl+shift+${n}";
            command = "vscode-harpoon.addEditor${n}";
          }
          {
            key = "ctrl+${n}";
            command = "vscode-harpoon.gotoEditor${n}";
          }
          {
            command = "-workbench.action.openEditorAtIndex${n}";
            key = "alt+${n}";
          }
          {
            key = "ctrl+${n}";
            command = "-workbench.action.focusThirdEditorGroup";
          }
        ]) (lib.lists.range 1 9));
    userSettings = with builtins;
      fromJSON (readFile "${inputs.self}/confs/code/settings.json");
  };
}
