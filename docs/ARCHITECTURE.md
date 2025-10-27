
# Architecture Guide

> Repository: `drlucaa/nixconfig`  
> Author intent: Personal multi‑system (Linux + Darwin) NixOS / Home Manager environment with custom packages and theming.  
> NOTE: Some directory listings were subject to API result limits; if you add/remove modules, update this document accordingly.

---

## 1. High-Level Overview

This repository is a declarative Nix flake that composes:

- A curated set of upstream inputs (stable `nixos-25.05`, `nixpkgs-unstable`, rust overlays, editors, tools).
- System-level configuration (NixOS modules + hardware definitions).
- User-level environment (Home Manager modules).
- Local package overrides / custom derivations (`programs/`).
- Theming & raw configuration assets (`confs/`, `assets/`).
- Development tooling via `flake-parts` (`parts/`).
- Cross-platform support for `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`.

The flake uses `flake-parts` for structured composition and overlays for tight control over package versions.

---

## 2. Design Goals & Principles

| Goal | Explanation |
|------|-------------|
| Reproducibility | Pin inputs via `flake.lock` and selective `follows` for consistency. |
| Cross-platform | Support Linux (x86_64/aarch64) and Apple Silicon (`aarch64-darwin` / `apple-silicon`). |
| Modularity | One module per concern (program, service, theme) enables selective reuse. |
| Hackability | Track upstream master branches (e.g. Helix, JJ) for latest features. |
| Separation of concerns | System vs user vs raw assets vs package build logic. |
| Theming consistency | Use external theme sources (gruvbox, nix-colors) to derive palettes. |
| Evolvability | `parts/` prepares for migration to more granular `flakeModules`. |

---

## 3. Directory Structure

| Path | Role | Notes / Guidance |
|------|------|------------------|
| `flake.nix` | Entry point | Defines inputs, systems, overlays, imports `parts/`. |
| `parts/` | Flake outputs fragments | `devshell.nix`, `treefmt.nix`, `nixos.nix`, `hm.nix`, `packages.nix`. Each contributes to final flake outputs. |
| `hardware/` | Host hardware profiles | Currently `pc.nix`. Add new `<host>.nix` per machine. |
| `nixosModules/` | System (NixOS) modules | GPU (`nvidia.nix`), compositor (`niri.nix`), base (`basic.nix`), extras (`steam.nix`). |
| `hmModules/` | Home Manager modules | One file per program/service/theme; can be grouped later. |
| `mixins/` | Small reusable fragments | `pkgs.nix` seeds package sets; candidate for consolidation. |
| `programs/` | Local derivations / overrides | `zx`, `helix`, `ghbrowse`, `clipboard`. Imported via overlays. |
| `confs/` | Raw config assets | Themes, keymaps, wallpapers (`bgs`), compositor & shell configs. |
| `assets/` | User assets | SSH public keys & misc config—avoid secrets. |
| `firmware/` | Binary firmware blobs | Large Apple Silicon firmware; consider externalizing. |
| `templates/` | Reserved for scaffolding | Currently empty; use for future module/package templates. |
| `README.md` | Quick start usage | Basic operational instructions. |
| `CRUSH.md` | Internal note | Refactoring reminder / conceptual comment. |
| `package.json` | Node ecosystem metadata | Likely only for tooling (e.g. format hooks). |
| `.envrc` | direnv integration | Ensures environment bootstrapping. |

---

## 4. Flake Architecture

### Inputs Layer
- Stable + Unstable nixpkgs separation: `nixpkgs` (stable release channel) vs `nixpkgs-unstable` for bleeding-edge packages.
- Tooling flakes: `rust-overlay`, `jj-vcs/jj`, `helix-editor/helix`, `niri-flake`, `nix-index-database`, etc.
- Themes: `gruvbox-dark-yazi`, `alacritty-theme`, `nix-colors`.
- Local / personal forks: `oleina-nixpkgs`, `antholeole/nixzx`.

Selective `follows` is used to:
- Align dependent flakes (`niri-flake`, `nur`, `nixGL`, etc.) with a specific `nixpkgs` input to avoid evaluation mismatch.
- Track unstable only where necessary (development/rust-heavy contexts).

### Outputs via `flake-parts`
`mkFlake` defines:
- `systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ]`.
- `perSystem`:
  - Constructs `pkgs` with overlays.
  - Enables `allowUnfree`.
  - Injects custom package builder logic.

### Imports
`flake.nix` imports:
```
./parts/devshell.nix
./parts/treefmt.nix
./parts/nixos.nix
./parts/hm.nix
./parts/packages.nix
```
Each part likely contributes:
- `devShells`
- Formatters / `treefmt`
- `nixosConfigurations`
- `homeConfigurations`
- `packages` (exposed build artifacts)

---

## 5. Cross-Platform Strategy

- Systems triple targets allow Apple Silicon development while still building Linux-specific modules (e.g., Nvidia GPU).
- Darwin-specific logic is implicitly limited—ensure overlays or modules gracefully handle absence of Linux-only features.
- Recommendation: Introduce optional gating (e.g. `lib.optionalAttrs (pkgs.stdenv.isLinux) { ... }`) inside modules.

---

## 6. Overlay Strategy

Overlays combined inside `perSystem`:

Order matters:
1. Third-party overlays (`nixGL`, `rust-overlay`, `nur`, `niri-flake`, `nixzx`)
2. Custom inline overlay merging:
   - Imports local program packages (`programs/zx`, `programs/ghbrowse`, etc.).
   - Rebinds certain flake packages (`helix`, `zjstatus`, `jujutsu`, `quickshell`) to their upstream flake’s default output for current system.

Helper pattern (simplified):
```nix
(final: prev: let
  zx-packages = import (./programs/zx) prev;
  dft = imprt: imprt.packages.${prev.system}.default;
in
  zx-packages // {
    helix     = dft helix;
    zjstatus  = dft zjstatus;
    jujutsu   = dft jujutsu;
    quickshell = dft quickshell;
    ghbrowse  = (import ./programs/ghbrowse) prev;
})
```

Refactor Suggestion:
- Externalize to `overlays/` directory for readability.
- Provide per-overlay purpose in comments.

---

## 7. Module Layers

### NixOS Modules (`nixosModules/*`)
- Focus on base system config, GPU, compositor, gaming (steam).
- Keep these declarative; avoid user-space config duplication—delegate to HM modules where appropriate.

### Home Manager Modules (`hmModules/*`)
- One file per domain: editor (`helix.nix`), terminal (`alacritty.nix`), shell (`fish.nix`), multiplexers (`zellij.nix`), theming (`theme.nix`), WM (`niri.nix`), etc.
- Larger modules (`helix.nix`, `zellij.nix`, `k9s.nix`) likely embed internal config templates; consider extracting large static payloads to `confs/` and referencing them for clarity.

### Duplication Risk
Example: `niri.nix` appears both system + user level. Share common configuration via an intermediate `modules/common/niri-core.nix`.

---

## 8. Program Packaging & Local Overrides

Local derivations under `programs/`:
- Provide patched or updated versions beyond upstream nixpkgs.
- Overridden inside overlays for consistency across environments.

Add new custom package:
1. Create `programs/<name>/default.nix`.
2. Import inside overlay block or create dedicated overlay file.
3. Expose via `packages` output if generally useful.

---

## 9. Configuration Assets

`confs/` holds raw config artifacts:
- Separation keeps Nix expressions lean.
- Access pattern: HM or NixOS modules should `builtins.readFile` or symlink these where appropriate.
- Suggest substructure conventions:
  - `confs/niri/` → compositor layouts
  - `confs/quickshell/` → shell UI components
  - `confs/theme/` → color definitions (if not generated dynamically)

Wallpapers / backgrounds under `confs/bgs`: Consider a naming prefix (e.g. `wallpaper-<descriptor>.png`).

---

## 10. Mixins & Profiles

Current `mixins/pkgs.nix` implies a start toward reusable fragments.
Recommended evolution:
- Introduce `profiles/`:
  - `profiles/dev.nix` (dev tools bundle)
  - `profiles/gaming.nix`
  - `profiles/video-editing.nix`
- Profiles import sets of HM modules and NixOS modules:
```nix
{
  imports = [
    ../hmModules/helix.nix
    ../hmModules/fish.nix
    ../hmModules/dev.nix
    # ...
  ];
}
```
Then hosts simply select profiles rather than enumerating every module.

---

## 11. Firmware Handling

`firmware/` contains large Apple Silicon blobs:
- Pros: Local pinning, offline availability.
- Cons: Repository size growth, slower clones.
Options:
1. External firmware repo + `fetchurl` with hash.
2. Cachix / binary cache distribution.
3. Git LFS (if not needed by evaluation graph directly).

---

## 12. Development Tooling

- `parts/treefmt.nix` integrates `treefmt-nix` → standardized formatting.
- `parts/devshell.nix` defines ephemeral developer shell (likely with pinned tools).
- `parts/packages.nix` exposes a curated package set (e.g. custom overrides).
- Use `nix develop` or `direnv` via `.envrc` for automatic shell activation.

---

## 13. Theming

Sources:
- `gruvbox-dark-yazi` (non-flake).
- `alacritty-theme` (non-flake).
- `nix-colors` (flake, can generate palettes programmatically).

Suggested Consolidation:
- Single `theme.nix` module deriving palette from `nix-colors`.
- Downstream modules (helix, alacritty, yazi, fuzzel) consume a standardized attribute set:
```nix
{
  colors = {
    bg = "#282828";
    fg = "#ebdbb2";
    accent = palette.orange;
    # ...
  };
}
```
- Generate config files via template rendering or inline Nix string interpolation.

---

## 14. Dependency Flow Diagram

```
           +----------------------+
           |      flake.nix       |
           |  inputs + mkFlake    |
           +----------+-----------+
                      |
                +-----v------+
                |  parts/    | (nixos, hm, devshell, packages, treefmt)
                +-----+------+
                      |
        +-------------+----------------+
        |                              |
+-------v--------+             +-------v--------+
| nixosModules/  |             | hmModules/     |
| system modules |             | user modules   |
+-------+--------+             +-------+--------+
        |                              |
        |               +--------------+------------+
        |               |  confs/ (raw assets)      |
        |               +--------------+------------+
        |                              |
+-------v--------+             +-------v--------+
| hardware/      |             | programs/      | (custom derivations)
+-------+--------+             +-------+--------+
        |                              |
        +--------------+---------------+
                       |
                +------v------+
                |  overlays   | (merges upstream + local pkgs)
                +------+------+
                       |
                +------v------+
                |   pkgs      |
                +-------------+
```

---

## 15. Refactor Roadmap (Incremental)

| Step | Action | Benefit |
|------|--------|---------|
| 1 | Create `overlays/` directory | Readability, testability |
| 2 | Introduce `profiles/` for HM & NixOS | Reduce duplication |
| 3 | Shared `modules/common/` layer | Unify cross-cutting config (e.g. compositor) |
| 4 | Consolidate micro HM modules into thematic groups | Lower file count, easier navigation |
| 5 | Externalize large firmware | Faster clone & evaluation |
| 6 | Normalize naming & fix typos (`xresources.nix`, `jujutsu.nix`) | Consistency |
| 7 | Convert theme logic to palette-driven module | Single source of truth |
| 8 | Add `docs/` directory for each domain README | Onboarding clarity |
| 9 | Adopt `flake-parts` custom flake modules (`flakeModules`) | Stronger architectural boundaries |
| 10 | Add tests: evaluation smoke test per system | Early detection of breakages |

---

## 16. Naming & Conventions

| Item | Convention |
|------|------------|
| Module file | `snake-case.nix` describing domain (`fish.nix`, `zellij.nix`). |
| Profiles | `profiles/<purpose>.nix` |
| Shared abstractions | `modules/common/<topic>.nix` |
| Hardware | `hardware/<host>.nix` |
| Overlays | `overlays/<name>.nix` |
| Program derivations | `programs/<name>/default.nix` |
| Theme palette | `modules/common/theme.nix` or `theme/` folder |

---

## 17. Adding a New Host

1. Create `hardware/<hostname>.nix` with hardware-specific options.
2. (Optional) Create `hosts/<hostname>/configuration.nix` (if adopting host directory pattern).
3. Add a host entry in `parts/nixos.nix` (or future `flakeModule`) like:
```nix
{
  nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hardware/<hostname>.nix
      ./nixosModules/basic.nix
      # profiles/dev.nix (future)
    ];
  };
}
```
4. Rebuild: `sudo nixos-rebuild switch --flake .#<hostname>`.

---

## 18. Adding a New Program (User-Level)

1. If pure config: Add `hmModules/<program>.nix`.
2. If custom build:
   - Create `programs/<program>/default.nix`.
   - Extend overlay to include it.
   - Optionally expose via `packages.<program>`.
3. Import module via profile or host-specific HM configuration.

---

## 19. Introducing a Shared Module

Example: unify `niri` config (system + user):

`modules/common/niri-core.nix`:
```nix
{ lib, ... }:
{
  options.common.niri.enable = lib.mkEnableOption "Shared niri config (system + user)";
  config = lib.mkIf config.common.niri.enable {
    # shared settings, fonts, keymaps from confs/niri/
  };
}
```
Then in `nixosModules/niri.nix` and `hmModules/niri.nix`:
```nix
{ ... }: {
  imports = [ ../modules/common/niri-core.nix ];
  common.niri.enable = true;
  # layer system/user specifics
}
```

---

## 20. Security Considerations

| Area | Consideration | Action |
|------|---------------|--------|
| `assets/` | Contains public keys | Ensure no private keys / secrets. |
| Firmware | Potential license constraints | Verify redistribution terms. |
| Overlays | Trust upstream commits | Pin or track tags for critical software. |
| Custom packages | Build inputs | Audit dependencies for supply chain integrity. |

---

## 21. Future Enhancements

- CI Evaluation: Add GitHub Actions to evaluate all flake systems & run format checks (`nix flake check` + `treefmt`).
- Binary Cache: Introduce Cachix for large Apple Silicon builds.
- Module Testing: Minimal integration tests using `nixos-generators` for VM snapshots.
- Template Generation: Use `nix run .#generate-<thing>` patterns for new modules or profiles.

---

## 22. Known Issues / Debt

| Issue | Impact | Mitigation |
|-------|--------|------------|
| Duplication between NixOS & HM configs | Manual updates across files | Shared common modules + profiles |
| Inline overlay complexity | Harder maintenance | Externalize overlays |
| Large firmware footprint | Slower repo operations | Fetch externally |
| Typos (`xresouces.nix`) | Minor confusion | Rename & update imports |
| Granularity overhead | Cognitive load | Logical grouping (CLI bundle) |

---

## 23. Maintenance Checklist

Perform quarterly:
- `nix flake update` (review diffs; test rebuild on all systems).
- Validate Apple Silicon support still aligns with upstream `nixos-apple-silicon`.
- Run `treefmt` pre-commit.
- Prune unused modules or consolidate tiny ones.
- Reassess upstream master tracking (pin if instability increases).

---

## 24. Quick Reference Commands

| Task | Command |
|------|---------|
| Show outputs | `nix flake show` |
| Switch NixOS | `sudo nixos-rebuild switch --flake .#pc --impure` |
| Switch Home Manager | `home-manager switch --flake .#<hm-config> --impure -b backup` |
| Dev shell | `nix develop` (via `.envrc`) |
| Format | `nix run .#treefmt` or `treefmt` inside devShell |

---

## 25. Glossary

| Term | Definition |
|------|------------|
| Flake | Nix packaging and configuration format with explicit inputs/outputs. |
| Overlay | A function modifying or extending `pkgs` (package set). |
| Module | Declarative configuration unit providing options + config. |
| Profile | (Proposed) Aggregation of modules serving a functional role. |
| HM | Home Manager—user-level configuration system built on Nix. |

---

## 26. Attribution & Acknowledgements

Upstream resources leveraged:
- [nixpkgs](https://github.com/NixOS/nixpkgs)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
- [home-manager](https://github.com/nix-community/home-manager)
- [nix-colors](https://github.com/misterio77/nix-colors)
- Tool-specific flakes (Helix, JJ, niri, nix-index, rust-overlay, etc.)

---

## 27. Updating This Document

When adding:
- New module: Update section 7 or profile strategy.
- New overlay: Update section 6 & overlay diagram.
- New host: Update section 17.
- Theme changes: Update section 13.

---

### Final Note

You previously noted the need for refactoring (README). This document formalizes a path forward. Start with overlays + profiles; that unlocks most future simplifications with minimal immediate risk.

Happy hacking!
