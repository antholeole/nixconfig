{ pkgs, lib, ... }:
let
  isArm = pkgs.system == "aarch64-linux";
in
{
  home.packages = with pkgs; [
    terraform
  ] ++ lib.optional (!isArm) terraform-ls;

  programs.helix.languages = lib.mkIf (!isArm) {
    language = [
      {
        name = "hcl";
        language-servers = ["terraform-ls"];
        formatter = {
          command = "${pkgs.terraform}/bin/terraform";
          args = ["fmt" "-"];
        };
      }
    ];

    language-server = {
      terraform-ls = {
        command = "terraform-ls";
        # https://github.com/helix-editor/helix/discussions/9630
        args = ["serve" "-log-file" "/dev/null"];
      };
    };
  };
}
