{
  pkgs,
  pkgs-unstable,
  config,
  mkWaylandElectronPkg,
  inputs,
  lib,
  ...
}: let
  cfg = config.programs.vscode;

  userSettingsPath = "${config.home.homeDirectory}/.config/Code/User";
  configFilePath = "${userSettingsPath}/settings.json";
  keybindingsFilePath = "${userSettingsPath}/keybindings.json";

  machineBased = {
    settings = with pkgs; {
      "direnv.path.executable" = "${direnv}/bin/direnv";
      "D2.execPath" = "${d2}/bin/d2";
      "biome.lsp.bin" = "${biome}/bin/biome";
      "clangd.path" = "${pkgs-unstable.llvmPackages_19.clang-tools}/bin/clangd";
      "git.path" = "${config.programs.git.package}/bin/git";
      "alejandra.program" = "${alejandra}/bin/alejandra";
      "metals.sbtScript" = "${sbt}/bin/sbt";
      "metals.javaHome" = "${jdk8}/lib/openjdk";
    };

    tasks = {
    };
  };
in rec {
  programs.vscode = with builtins;
    lib.mkIf (!config.conf.headless) {
      enable = true;

      package = let
        # TODO: unpin vscode. The current bugs that require me to stay
        # on an old version are when opening the integrated terminal,
        # the size does not immediately adjust and we end up using a half
        # terminal every other integrated terminal open.
        code =
          (import inputs.nixpkgs-with-vsc {
            config.allowUnfree = true;
            system = pkgs.system;
          })
          .vscode;

        rawCode = inputs.nix-riced-vscode.packages.${pkgs.system}.ricedVscodium {
          pkg = code;
          js = ["${inputs.self}/confs/code/injected/floating_pallet.js"];
          css = [
            "${inputs.self}/confs/code/injected/floating_pallet.css"
            "${inputs.self}/confs/code/injected/letterpress.css"
            "${inputs.self}/confs/code/injected/remove-favicon.css"
          ];
        };

        waylandWrapped =
          mkWaylandElectronPkg {
            pkg = rawCode;
            exeName = "code";
          }
          // (with rawCode; {inherit pname version;});
        # TODO this may be broken. try --disable-gpu or xwayland.
      in
        waylandWrapped;

      enableUpdateCheck = false;
      mutableExtensionsDir = false;

      extensions = let
        extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
        vsc-version = config.programs.vscode.package.version;
      in [
        #theme
        extensions.vscode-marketplace.jonathanharty.gruvbox-material-icon-theme
        extensions.open-vsx.jdinhlife.gruvbox

        # good stuff
        extensions.open-vsx.gregoire.dance
        extensions.vscode-marketplace.tobias-z.vscode-harpoon
        vscode-extensions.eamodio.gitlens
        extensions.open-vsx.usernamehw.errorlens
        extensions.vscode-marketplace.dyno-nguyen.vscode-dynofileutils

        # open-vsx.jeanp413.open-remote-ssh TODO: determine if this is safe
        extensions.vscode-marketplace.ms-vscode-remote.remote-ssh # This is incompatible with codium :(
        extensions.vscode-marketplace.tyriar.lorem-ipsum
        extensions.open-vsx.mechatroner.rainbow-csv
        extensions.open-vsx.ban.spellright

        # languages
        # cpp
        extensions.open-vsx.llvm-vs-code-extensions.vscode-clangd

        # go
        extensions.open-vsx.golang.go

        # md
        extensions.open-vsx.yzhang.markdown-all-in-one

        # toml
        extensions.open-vsxtamasfe.even-better-toml

        # scala
        extensions.open-vsx.scalameta.metals

        # nix
        extensions.open-vsx.kamadorueda.alejandra
        extensions.open-vsx.bbenoist.nix
        extensions.open-vsx.mkhl.direnv

        # rust
        pkgs.vscode-extensions.rust-lang.rust-analyzer

        # ts / js
        extensions.open-vsx.biomejs.biome # this sometimes conflicts with non-biome projects but its a nice default editor

        # python
        extensions.open-vsx.charliermarsh.ruff
        (extensions.forVSCodeVersion vsc-version).vscode-marketplace.ms-python.python
        (extensions.vscode-marketplace.ms-python.vscode-pylance.overrideAttrs (
          old: {
            forVSCodeVersion = vsc-version;
          }
        ))
      ];
      keybindings = let
        directionKeymap = dir: commandFn:
          (import "${inputs.self}/shared/arrows.nix") {
            inherit dir commandFn lib;
          };

        oneToTen = with builtins;
          lib.lists.flatten (map (nInt: let
            n = toString nInt;
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
          mkDirectional = {
            side,
            keycode,
          }: let
            fs = {
              ours =
                if side == "left"
                then "First"
                else "Second";
              other =
                if side == "left"
                then "Second"
                else "First";
            };

            lr = {
              other =
                if side == "left"
                then "Right"
                else "Left";
              ours =
                if side == "left"
                then "Left"
                else "Right";
            };

            idx = {
              ours = builtins.toString (
                if side == "left"
                then 1
                else 2
              );
              other = builtins.toString (
                if side == "left"
                then 2
                else 1
              );
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
        in
          lib.lists.flatten keybinds;
      in
        oneToTen ++ raw ++ directional;

      userSettings = let
        ignoresList = import "${inputs.self}/shared/ignores.nix";
      in
        with builtins; ((builtins.fromJSON
            (readFile "${inputs.self}/confs/code/settings.json"))
          // machineBased.settings
          // {
            "terminal.integrated.profiles.linux" = {
              "fish" = {
                path = "${pkgs.lib.getExe config.programs.fish.package}";
                args = [
                  "-C"
                  ''${pkgs.zellij}/bin/zellij a -c "$(basename (pwd))"''
                ];
              };
            };

            "dynoFileUtils.folderExclude" = ignoresList;

            "search.exclude" = with builtins; let
              # the format we use in ignores.nix is "path/"; we need "**/path/"
              mapToExpectedFormat = dir: "**/${dir}";
              asNvList =
                map (toIgnore: {
                  name = mapToExpectedFormat toIgnore;
                  value = true;
                })
                ignoresList;
              asTrueMap = listToAttrs asNvList;
            in
              asTrueMap;
          });
    };

  # this file doesn't hurt if its not a headless VM, we don't make a
  # distinction. this allows us to SSH into a non-headless VM and still be able
  # to use it normally.
  home.file.".vscode-server/data/Machine/settings.json" = {
    enable = true;
    text = builtins.toJSON machineBased.settings;
  };

  home.activation.makeVSCodeConfigWritable = let
    configDirName =
      {
        "vscode" = "Code";
        "vscode-insiders" = "Code - Insiders";
        "vscodium" = "VSCodium";
      }
      .${config.programs.vscode.package.pname};
    configPath = "${config.xdg.configHome}/${configDirName}/User/settings.json";
  in {
    after = ["writeBoundary"];
    before = [];
    data = ''
      install -m 0640 "$(readlink ${configPath})" ${configPath}
    '';
  };
}
