# Dots — NixOS Configuration Architecture

This repository is structured around a modular, per-concern NixOS configuration
system. Rather than one monolithic `configuration.nix`, settings are split by
concern, by target device, and by whether they apply globally or only to a
specific machine.

## High-Level Flow

```
configuration.nix
      │
      │ (modification folder)
      ▼
 Configuration
      │
      ├──▶ Target System Modifications ──▶ desktop
      │                                └─▶ laptop ──▶ Gpd-Duo
      │
      ├──▶ Global Modifications
      │
 Modules
        │
        ▼
   default.nix
(decides which target + modules to use)
```

`configuration.nix` remains the original entry point, but now feeds into a
`Configuration` node that fans out into three concerns:

1. **Target System Modifications** — setup specific to a device *class*
   (`desktop`, `laptop`), which further route into shared building blocks
   (`System-packages.nix`, `fonts.nix`, `alias.nix`) and, for `laptop`,
   into device-specific overrides under `Gpd-Duo`.
2. **Global Modifications** — settings intended to apply to *every* target
   system regardless of device class.
3. **Modules** — packages that require additional configuration (a service,
   a kernel module, a NixOS option) to actually function, paired directly
   with that configuration in the same file.

All three funnel into `default.nix`, which is the actual switchboard —
where you decide, per machine, which target and which modules get imported.

---

## Directory Structure

```
.
├── configuration.nix
├── default.nix                  # import injection / target selection
├── modules/                     # packages requiring extra config to function
│   ├── cloudflare-warp.nix
│   ├── docker.nix
│   ├── gh.nix
│   ├── lm-sensors.nix
│   ├── networkmanager.nix
│   ├── nginx.nix
│   ├── niri.nix
│   ├── polkit.nix
│   ├── vulkan-tools.nix
│   ├── xdg-portal.nix
│   └── zsh.nix
├── global/                      # applies to all target systems
│   ├── alias.nix
│   ├── fonts.nix
│   └── system-packages.nix
├── desktop/                     # desktop-class target
│   └── ...
└── laptop/                      # laptop-class target
    └── gpd-duo/                 # device-specific overrides
        ├── audio.nix
        ├── display.nix
        ├── locale.nix
        ├── networking.nix
        ├── power.nix
        ├── swap.nix
        ├── system-packages.nix
        └── system.nix
```

---

## Modules (`modules/`)

Packages in this folder are grouped here specifically because installing the
package alone is not enough — each requires a companion NixOS option, service,
or manual step to actually work. This folder exists to keep that pairing
visible and prevent "package installed but silently non-functional" traps.

| File                  | Package(s)                                            | Required companion config                                                                                                                                                                                |
| --------------------- | ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `cloudflare-warp.nix` | `cloudflare-warp`                                     | `warp-svc` daemon must be manually enabled post-install (`systemctl enable --now warp-svc`)                                                                                                              |
| `docker.nix`          | `docker`, `docker-compose`                            | `virtualisation.docker.enable`, user added to `docker` group                                                                                                                                             |
| `gh.nix`              | `gh`                                                  | One-time manual auth (`gh auth login`)                                                                                                                                                                   |
| `lm-sensors.nix`      | `lm_sensors`                                          | May require `sudo sensors-detect` + resulting kernel module added to `boot.kernelModules`. On laptops, many sensors (CPU/GPU/NVMe/battery) work automatically via PCI/ACPI drivers with no setup needed. |
| `networkmanager.nix`  | `networkmanagerapplet`                                | `networking.networkmanager.enable`                                                                                                                                                                       |
| `nginx.nix`           | `nginx`                                               | `services.nginx.enable`                                                                                                                                                                                  |
| `niri.nix`            | `niri`, `fuzzel`, `alacritty`, `swaylock`, `swayidle` | `programs.niri.enable` (currently disabled — niri run without full session module integration)                                                                                                           |
| `polkit.nix`          | `polkit_gnome`                                        | `security.polkit.enable`; agent must be launched at session start manually (niri does not do this automatically)                                                                                         |
| `vulkan-tools.nix`    | `vulkan-tools`                                        | `hardware.graphics.enable`                                                                                                                                                                               |
| `xdg-portal.nix`      | `xdg-desktop-portal`, `xdg-desktop-portal-wlr`        | `xdg.portal.enable` + `extraPortals`                                                                                                                                                                     |
| `zsh.nix`             | — (via `programs.zsh`)                                | `programs.zsh.enable` required for `users.defaultUserShell` to work correctly                                                                                                                            |
| `etc` | `...` |   `...`

---

## Global (`global/`)

Applied to every target system regardless of device class.

- **`alias.nix`** — Shell alias definitions for navigating and managing the
  dotfiles/system config, plus quality-of-life overrides for common CLI tools
  (`ls`, `grep`, `find`, editor shortcuts, rebuild/update shortcuts).
- **`fonts.nix`** — System-wide font packages: general text rendering
  (Noto + color emoji) and a broad monospace/coding font set (Fira Code,
  JetBrains Mono, Hack, Meslo, Source Code Pro, Iosevka, Inconsolata,
  Cascadia Code, DejaVu), including the Fira Code Nerd Font variant for
  icon/glyph support in tools expecting Nerd Font glyphs.
- **`system-packages.nix`** — Baseline package list for every machine:
  Wayland/niri session utilities, hardware/power CLI tools, video playback,
  system monitoring, archive handling, core networking clients, shell
  replacements (`eza`/`fd`/`ripgrep`/`starship`), terminal emulator,
  browsers, the full development toolchain, Discord, and GTK/Qt runtime
  libraries for GUI apps under Wayland/niri.

---

## Laptop → Gpd-Duo (`laptop/gpd-duo/`)

Device-specific overrides and hardware quirks unique to the GPD Duo unit
(Config B — AMD Ryzen AI 9 HX 370 + Radeon 890M).

- **`audio.nix`** — PipeWire as the audio server (PulseAudio disabled),
  WirePlumber session management, ALSA + 32-bit support, PulseAudio-
  compatible interface, and `rtkit` for real-time audio scheduling priority.
- **`display.nix`** — Kernel-level fix for the GPD Duo's known factory
  display defect: the internal eDP panel ships physically upside down.
  Forces correct resolution + orientation on the internal panel and a
  matching resolution on the external DP output to keep both in sync.
- **`locale.nix`** — Reserved for locale-related settings; currently empty.
- **`networking.nix`** — Sets hostname (`CyberDeckDuo`) and firewall rules
  with specific TCP ports opened for local dev/services.
- **`power.nix`** — Power profile management, automatic hibernate at 10%
  battery, AMD P-State active driver, NVMe power-state tuning, and
  hibernation resume configuration (offset + resume device — tightly
  coupled to `swap.nix`, see note below).
- **`swap.nix`** — Defines the swapfile used for both regular swap and
  hibernation. **Coupled to `power.nix`**: any change to swapfile size or
  path here requires recalculating `resume_offset` in `power.nix`, or
  hibernation will silently break.
- **`system-packages.nix`** — Device-specific audio utilities layered on
  top of `audio.nix` (`pavucontrol`, `alsa-utils`).
- **`system.nix`** — Core hardware/base config: hostname (forced), firmware,
  AMD microcode, graphics stack (Mesa + 32-bit), Bluetooth, touchpad
  (libinput), lid-close-to-hibernate behavior, and boot verbosity.

---

## Known Coupling Between Files

Some settings span multiple files without that relationship being visible
from Nix syntax alone. Worth keeping in mind when editing:

- **`power.nix` ↔ `swap.nix`** — `resume_offset` in `power.nix` is derived
  from the exact swapfile defined in `swap.nix`. Changing the swapfile
  invalidates the offset.
- **`system.nix` ↔ `networking.nix`** — both currently set `hostName`
  (`system.nix` via `lib.mkForce`, `networking.nix` as a plain string).
  Same value today, so no conflict — but `mkForce` will always win if they
  ever diverge, which can be non-obvious to debug later.
- **`audio.nix` ↔ `laptop/gpd-duo/system-packages.nix`** — `pavucontrol`
  and `alsa-utils` are GUI/CLI tools for the PipeWire setup declared in
  `audio.nix`; they depend on that service being enabled to function.
