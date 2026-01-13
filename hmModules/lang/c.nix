{ pkgs, ... }: {
  home.packages = with pkgs; [
    llvmPackages_20.clang-tools
    lldb_20
  ];

  programs.helix.languages = {
    language-server = {
      clangd = {
        args = [
          "--enable-config"
          "--clang-tidy"
        ];
      };
    };
  };

  xdg.configFile."clangd/config.yaml".text = ''
    CompileFlags:
      Add: [-Wall, -std=c++2b, -Wsuggest-override]
  '';
}
