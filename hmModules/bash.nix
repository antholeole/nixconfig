{ pkgs, ... }: {
  programs.bash = let fish = "${pkgs.fish}/bin/fish";
  in {
    enable = true;
    # on systems where we cannot configure the default shell, it helps to write
    # a bashrc to start fish, so we can use it anyway
    bashrcExtra = ''
      if [[ "$-" =~ i && -x "${fish}" && ! "''${SHELL}" -ef "${fish}" && -z "''${IN_NIX_SHELL}" ]]; then
        # Safeguard to only activate fish for interactive shells and only if fish
        # shell is present and executable. Verify that this is a new session by
        # checking if $SHELL is set to the path to fish. If it is not, we set
        # $SHELL and start fish.
        #
        # If this is not a new session, the user probably typed 'bash' into their
        # console and wants bash, so we skip this.
        exec env SHELL="${fish}" "${fish}" -i
      fi    
    '';
  };
}
