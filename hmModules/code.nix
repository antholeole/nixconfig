{ pkgs, config, mkWaylandElectronPkg, mkOldNixPkg, inputs, lib, sysConfig, ...
}:
let
  cfg = config.programs.vscode;

  userSettingsPath = "${config.home.homeDirectory}/.config/Code/User";
  configFilePath = "${userSettingsPath}/settings.json";
  keybindingsFilePath = "${userSettingsPath}/keybindings.json";

  machineBased = {
    settings = {
      "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
      "picat.executablePath" = "${pkgs.picat}/bin/picat";
      "D2.execPath" = "${pkgs.d2}/bin/d2";
      "biome.lspBin" = "${pkgs.biome}/bin/biome";
    };

    tasks = {

    };
  };
in {
  programs.vscode = with builtins; lib.mkIf (!sysConfig.headless) {
    enable = true;

    package = let
      # until https://github.com/microsoft/vscode/issues/204178 is fixed
      code_185 = (import inputs.nixpkgs-with-code-185 {
        config.allowUnfree = true;
        system = pkgs.system;
      }).vscode;

      rawCode = inputs.nix-riced-vscode.packages.${pkgs.system}.ricedVscodium {
        pkg = code_185;
        js = [ "${inputs.self}/confs/code/injected/floating_pallet.js" ];
        css = [
          "${inputs.self}/confs/code/injected/floating_pallet.css"
          "${inputs.self}/confs/code/injected/letterpress.css"
          "${inputs.self}/confs/code/injected/remove-favicon.css"
        ];
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
      open-vsx.mechatroner.rainbow-csv
      open-vsx.ban.spellright

      # languages
      open-vsx.bbenoist.nix
      open-vsx.golang.go
      open-vsx.yzhang.markdown-all-in-one
      open-vsx.scalameta.metals
      open-vsx.mkhl.direnv
      open-vsx.rust-lang.rust-analyzer

      open-vsx.arrterian.nix-env-selector
    ];
    keybindings = let
      directionKeymap = dir: commandFn:
        (import "${inputs.self}/shared/arrows.nix") {
          inherit dir commandFn lib;
        };

      oneToTen = with builtins;
        lib.lists.flatten (map (nInt:
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
              when = "editorTextFocus && dance.mode == 'normal'";
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

      raw = fromJSON (readFile "${inputs.self}/confs/code/keybindings.json");

      directional = let
        mkDirectional = { side, keycode }: let
          fs = {
            ours = if side == "left" then "First" else "Second";
            other = if side == "left" then "Second" else "First";
          };

          lr = {
            other = if side == "left" then "Right" else "Left";
            ours = if side == "left" then "Left" else "Right";
          };

          idx = {
            ours = builtins.toString (if side == "left" then 1 else 2);
            other = builtins.toString (if side == "left" then 2 else 1);
          };

        in [
          # resizing binds
          {
            key = "ctrl+shift+${keycode}";
            command = "workbench.action.decreaseViewWidth";
            when = "activeEditorGroupIndex == ${idx.ours} && dance.mode == 'normal' && editorTextFocus";
          }
          {
            key = "ctrl+shift+${keycode}";
            command = "workbench.action.increaseViewWidth";
            when = "activeEditorGroupIndex == ${idx.other} && dance.mode == 'normal' && editorTextFocus";
          }

          # switch sides binds 
          {
            key = "ctrl+${keycode}";
            command = "runCommands";
            args = {
              commands = [
                "workbench.action.focus${fs.ours}EditorGroup"
                "workbench.action.closeSidebar"
              ];
            };
            when = "activeEditorGroupIndex == ${idx.other} && !terminalFocus && !isInDiffEditor";
          }

          # if we are in the other side, we should switch side.
          {
            key = "ctrl+${keycode}";
            when = "isInDiff${lr.other}Editor";
            command = "diffEditor.switchSide";
          }

          # If we are in our own side, we are trying to get out of the 
          # diff editor. We should go to the other index.
          {
            key = "ctrl+${keycode}";
            when = "isInDiff${lr.ours}Editor";
            command = "workbench.action.focus${fs.ours}EditorGroup";
          }
        ];

        # this could probably be a combimatrix function.
        directions = [ 
          {
            side = "left";
            keycode = "left";
          }
          {
            side = "left";
            keycode = "h";
          }
          {
            side = "right";
            keycode = "right";
          }
          {
            side = "right";
            keycode = "l";
          }
         ];
        keybinds = builtins.map mkDirectional directions;
      in lib.lists.flatten keybinds;
    in oneToTen ++ raw ++ directional;

    userSettings = with builtins;
      ((builtins.fromJSON (readFile "${inputs.self}/confs/code/settings.json"))
        // machineBased.settings // {
          "terminal.integrated.profiles.linux" = {
            "fish" = {
              path = "${pkgs.lib.getExe config.programs.fish.package}";
              args =
                [ "-C" ''${pkgs.zellij}/bin/zellij a -c "$(basename (pwd))"'' ];
            };
          };

          "search.exclude" = with builtins;
            let
              # the format we use in ignores.nix is "path/"; we need "**/path/"
              mapToExpectedFormat = dir: "**/${dir}";

              asList = import "${inputs.self}/shared/ignores.nix";
              asNvList = map (toIgnore: {
                name = (mapToExpectedFormat toIgnore);
                value = true;
              }) asList;
              asTrueMap = listToAttrs asNvList;
            in asTrueMap;
        });
  };

  # this file doesn't hurt if its not a headless VM, we don't make a
  # distinction. this allows us to SSH into a non-headless VM and still be able
  # to use it normally.
  home.file.".vscode-server/data/Machine/settings.json" = {
    enable = true;
    text = builtins.toJSON machineBased.settings;
  };
}
