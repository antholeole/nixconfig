{ pkgs, config, mkWaylandElectronPkg, mkOldNixPkg, inputs, lib, sysConfig, ...
}:
let
  cfg = config.programs.vscode;

  userSettingsPath = "${config.home.homeDirectory}/.config/Code/User";
  configFilePath = "${userSettingsPath}/settings.json";
  keybindingsFilePath = "${userSettingsPath}/keybindings.json";
  # tasksFilePath = "${userSettingsPath}/tasks.json";
  # snippetsPath = "${userSettingsPath}/snippets";

  pathsToMakeWritable = lib.flatten [
    (lib.optional (cfg.userSettings != { }) configFilePath)
    (lib.optional (cfg.keybindings != { }) keybindingsFilePath)
    # (lib.optional (cfg.userTasks != { }) tasksFilePath)
    # (lib.optional (cfg.globalSnippets != { })
    # "${snippetsPath}/global.code-snippets")
    # (lib.mapAttrsToList (language: _: "${snippetsPath}/${language}.json")
    # cfg.languageSnippets)
  ];
in {
  programs.vscode = lib.mkIf (!sysConfig.headless) {
    enable = true;
    package = let
      rawCode = inputs.nix-riced-vscode.packages.${pkgs.system}.ricedVscodium {
        pkg = pkgs.vscode;
        js = [ "${inputs.self}/confs/code/injected/floating_pallet.js" ];
        css = [ "${inputs.self}/confs/code/injected/floating_pallet.css" ];
      };

      waylandWrapped = mkWaylandElectronPkg {
        pkg = rawCode;
        exeName = "code";
      } // (with rawCode; { inherit pname version; });

      # TODO this may be broken. try --disable-gpu or xwayland.
    in waylandWrapped;

    enableUpdateCheck = false;
    mutableExtensionsDir = true;

    extensions = let
      marketplace =
        inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
      open-vsx =
        inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
    in [
      #theme
      open-vsx.catppuccin.catppuccin-vsc
      open-vsx.catppuccin.catppuccin-vsc-icons

      # good stuff
      open-vsx.gregoire.dance
      marketplace.tobias-z.vscode-harpoon
      open-vsx.eamodio.gitlens
      open-vsx.mhutchie.git-graph
      open-vsx.usernamehw.errorlens
      marketplace.dyno-nguyen.vscode-dynofileutils
      # open-vsx.jeanp413.open-remote-ssh TODO: determine if this is safe
      marketplace.ms-vscode-remote.remote-ssh # This is incompatible with codium :(
      marketplace.tyriar.lorem-ipsum
      open-vsx.arrterian.nix-env-selector

      # languages
      open-vsx.bbenoist.nix
      open-vsx.golang.go
      open-vsx.yzhang.markdown-all-in-one
      open-vsx.scalameta.metals
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

  #home.file = lib.genAttrs pathsToMakeWritable (_: {
  #  force = true;
  #  mutable = true;
  #});
}
