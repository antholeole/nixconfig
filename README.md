# Quick start (nixos)
- `nix flake show` to see all outputs
- `sudo nixos-rebuild switch --flake .#` (for example, kayak-asaki, for kayak on asahi linux)

# HomeManager only: 
1. Install nix
1. enable flakes: `mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`


# Post install
- get the ssh private key from elsewhere

If you're using home-manager, you'll need to:
- copy `assets/authorized_keys` into `~/.ssh/authorized_keys`

I also include some stuff in /custom/, for configuration that I do not want to leak.
These are gitignored but they don't need to exist.

Chrome extensions I use but chrome doesn't lend itself to extensions well:
- vimium
- [quick tabs](https://chromewebstore.google.com/detail/quick-tabs/jnjfeinjfmenlddahdjdmgpbokiacbbb)