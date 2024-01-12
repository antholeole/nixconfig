{ pkgs, config, mkWaylandElectronPkg, mkOldNixPkg, inputs, lib, sysConfig, ...
}: {
  programs.vscode = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = let
      waylandWrapped = let vscode = pkgs.vscode;
      in mkWaylandElectronPkg {
        pkg = pkgs.vscode;
        exeName = "code";
      } // (with vscode; { inherit pname version; });

      # TODO this may be broken. try --disable-gpu or xwayland.
      finalCode = waylandWrapped;
    in finalCode;

    enableUpdateCheck = false;

    extensions = let
      marketplace =
        inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
    in with marketplace; [
      #theme
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      # good stuff
      gregoire.dance
      tobias-z.vscode-harpoon
      eamodio.gitlens
      mhutchie.git-graph
      ms-vscode-remote.remote-ssh
      drcika.apc-extension
      tyriar.lorem-ipsum

      # languages
      bbenoist.nix
      golang.go
      yzhang.markdown-all-in-one
      rust-lang.rust-analyzer
      scalameta.metals
    ];
    keybindings = with builtins;
      (pkgs.lib.mkIf true)
      (fromJSON (readFile "${inputs.self}/confs/code/keybindings.json") ++ [ ]
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
          ]) (lib.lists.range 1 9)) ++ (lib.lists.flatten (map (view: [{
            command = "workbench.action.closeSidebar";
            key = "ctrl+shift+${view.key}";
            when = "focusedView == 'workbench.view.${view.name}'";
          }]) [
            {
              key = "e";
              name = "explorer";
            }
            {
              key = "g";
              name = "scm";
            }
            {
              key = "f";
              name = "search";
            }
            {
              key = "d";
              name = "debug";
            }
            {
              key = "x";
              name = "extensions";
            }
          ])));
    userSettings = with builtins;
      ((fromJSON (readFile "${inputs.self}/confs/code/settings.json")) // {
        "terminal.integrated.profiles.linux" = {
          "fish" = {
            path = "${pkgs.lib.getExe config.programs.fish.package}";
            args = [
              "-C"
              "${pkgs.zellij}/bin/zellij --layout ~/.config/zellij/layouts/default.kdl"
            ];
          };
        };
      });
  };
}
