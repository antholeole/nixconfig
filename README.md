# Quick start (nixos)
- `nix flake show`to see all outputs
- `sudo nixos-rebuild switch --flake .#` (for example, kayak-asaki, for kayak on asahi linux)

# HomeManager only: 
1. Install nix
2. Install home-manager
3. `mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
4. `home-manager switch --flake github:antholeole/nixconfig#anthony --impure`. (you only need impure if nixGL is enabled)

# Getting Music added
enter the program `ncmpcpp` then click 2 to enter the browse menu. Then, click "a" on the folder to add the entire folder. 
