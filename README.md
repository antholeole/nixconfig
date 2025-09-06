# Quick start (nixos)

- `nix flake show` to see all outputs
- `sudo nixos-rebuild switch --flake .#pc --impure`

# HomeManager only:

1. Install nix
1. enable flakes: `mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`

# Post install

for hm, run `init-niri` to initalize the wm.

## Notes

this needs a refactor. I wouldn't copy the structure. If i have to update, say, niri in nixos and hm,
I have to do it across multiple files. Flake parts has https://flake.parts/options/flake-parts-flakemodules
for that.
