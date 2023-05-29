inputs: specialArgs: map (hmModulePath: {
    home-manager = {
      extraSpecialArgs = specialArgs;

      users.anthony = hmModulePath;
    };
  }) (import "${inputs.self}/hmModules" inputs)