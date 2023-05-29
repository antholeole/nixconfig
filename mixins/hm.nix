{ inputs, sysConfig, ... }: {
  home-manager = {
    extraSpecialArgs = {
      inherit inputs sysConfig;
    };

    modules = import "${inputs.self}/hmConfig" inputs;
  };
}