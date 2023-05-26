# Quick start (nixos)
- `nix flake show`to see all outputs
- `sudo nixos-rebuild switch --flake .#` (for example, kayak-asaki, for kayak on asahi linux)

# HomeManager only: 
you just need to get home-manager running on that machine. Then, run `home-manger switch --flake github:antholeole/nixconfig#anthony`.