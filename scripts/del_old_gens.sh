nix-env -p /nix/var/nix/profiles/system --delete-generations old
nix-collect-garbage -d

CURRENT_GEN=$(nix-env -p /nix/var/nix/profiles/system --list-generations | grep "(current)" | cut -b 2-4)

# Remove entries from /boot/loader/entries:
sudo bash -c "cd /boot/loader/entries; ls | grep -v $CURRENT_GEN | xargs rm"