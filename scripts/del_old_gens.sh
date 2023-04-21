nix-env -p /nix/var/nix/profiles/system --delete-generations old
nix-collect-garbage -d
nix-env -p /nix/var/nix/profiles/system --list-generations
# Remove entries from /boot/loader/entries:
sudo bash -c "cd /boot/loader/entries; ls | grep -v $1 | xargs rm"