# Quick start (nixos)
- `nix flake show`to see all outputs
- `sudo nixos-rebuild switch --flake .#` (for example, kayak-asaki, for kayak on asahi linux)

# HomeManager only: 
you just need to get home-manager running on that machine. Then, run `home-manger switch --flake github:antholeole/nixconfig#anthony --impure`.
(you only need impure if nixGL is enabled)

# Getting Music added
enter the program `ncmpcpp` then click 2 to enter the browse menu. Then, click "a" on the folder to add the entire folder. 
