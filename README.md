# Quick start (nixos)

- `nix flake show` to see all outputs
- `sudo nixos-rebuild switch --flake .#pc --impure`

# HomeManager only:

1. Install nix
1. enable flakes: `mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
1. git clone this repo
1. activate home-manager via a temporary install. `nix shell home-manager`
1. run `home-manager switch --flake .#<hm-config> --impure -b backup`. for
   example, "headless-work" for `<hm-config>`
1. make sure you use the fish in `~/.nix-profile/bin`, it has a custom init
   built in.

# Post install

for hm, run `init-niri` to initalize the wm.

## Notes

this needs a refactor. I wouldn't copy the structure. If i have to update, say, niri in nixos and hm,
I have to do it across multiple files. Flake parts has https://flake.parts/options/flake-parts-flakemodules
for that.
