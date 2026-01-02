{...}: {
  perSystem = {
    system,
    pkgs,
    lib,
    config,
    ...
  }: {
    packages.netdbg = pkgs.dockerTools.buildLayeredImage {
      name = "netdbg";
      tag = "latest";

      contents = with pkgs; let
        core = [
          fish
          bashInteractive
          coreutils
          busybox
          cacert
        ];

        netbasics = [
          iproute2
          iputils
          dnsutils
          netcat-gnu
          tcpdump
          nmap
          mtr
          socat
          jq
          openssl
          ethtool
          conntrack-tools
          curl
        ];

        extra = [
          google-cloud-sdk
          fzf
        ];
      in
        core ++ netbasics ++ extra;

      config = {
        Cmd = ["${pkgs.fish}/bin/fish"];

        Env = [
          "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          "SYSTEM_CERTIFICATE_PATH=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          "fish_greeting="
        ];
      };
    };
  };
}
