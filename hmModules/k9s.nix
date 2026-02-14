{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  gruvbox-dark-medium = "gruvbox-dark-medium";
in {
  programs.k9s = {
    enable = builtins.elem "kubectl" config.conf.features;
    package = pkgs.symlinkJoin {
      name = "k9s";
      paths = [pkgs-unstable.k9s];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/k9s \
          --set KUBECACHEDIR ${config.conf.homeDirPath}${config.conf.name}/.kube/cache \
          --set K9S_FEATURE_GATE_NODE_SHELL true
      '';
    };

    plugins = {
      "start-throwaway-pod" = {
        shortCut = "Ctrl-T";
        confirm = false;
        description = "Start an throwaway pod in current context/namespace";
        scopes = ["pods" "deployments"];
        command = "bash";
        background = true;
        args = [
          "-c"
          ''
            echo '${(let
              app = "oleina-throwaway";
            in
              builtins.toJSON {
                apiVersion = "apps/v1";
                kind = "Deployment";
                metadata = {
                  name = app;
                  labels = {
                    inherit app;
                    debug = "1";
                  };
                };
                spec = {
                  selector = {
                    matchLabels = {
                      inherit app;
                    };
                  };
                  replicas = 1;
                  template = {
                    metadata = {
                      labels = {
                        inherit app;
                        debug = "1";
                      };
                      annotations = {
                        "kubectl.kubernetes.io/default-container" = app;
                      };
                    };
                    spec = {
                      containers = [
                        {
                          name = "curl";
                          image = "ghcr.io/antholeole/nixconfig:latest";
                          imagePullPolicy = "Always";
                          securityContext = {
                            runAsUser = 0;
                            runAsGroup = 0;
                          };
                          stdin = true;
                          tty = true;
                          stdinOnce = true;
                          terminationMessagePath = "/dev/termination-log";
                          terminationMessagePolicy = "File";
                          resources = {
                            requests = {
                              cpu = "100m";
                              memory = "100Mi";
                            };
                            limits = {
                              cpu = "100m";
                              memory = "100Mi";
                            };
                          };
                        }
                      ];
                      restartPolicy = "Always";
                    };
                  };
                };
              })}' | kubectl apply -f - --context $CONTEXT --namespace $NAMESPACE
          ''
        ];
      };
    };

    settings.k9s = {
      ui = {
        headless = true;
        logoless = true;
      };

      featureGates = {
        nodeShell = true;
      };

      skipLatestRevCheck = true;

      logger = {
        tail = 100;
        buffer = 5000;
        sinceSeconds = -1;
        fullScreenLogs = false;
        textWrap = false;
        showTime = false;
      };
    };
  };
}
