<p align="center"><img align="center" src="logo.png" width="370px"></p>

## About

ZorrOS is a high level [NixOS](https://nixos.org/) configuration which aims to
create a productive development environment with open source tooling and minimal
distraction. It is written with emphasis on being both portable and scalable -
many modules can be used elsewhere with little or no modification. Home manager
modules and nix modules are automatically imported by the flake and are
differentiated with the `h` or `n` infix which respectively delineate home
manager modules and nix modules.

## Installation

1. Install NixOS either with the
   [official method](https://nixos.org/manual/nixos/stable/#ch-installation) or
   in place via [nixos-infect](https://github.com/elitak/nixos-infect) on a
   newly provisioned system.

2. Download the configuration:

```bash
cd /etc/nixos

git init

git remote add origin https://github.com/jameschubbuck/nixos-config.git

git fetch origin

git merge origin/main --allow-unrelated-histories
```

> [!WARNING]
> This may overwrite your current configuration. Use with caution.

3. Generate a machine-specific hardware configuration if one does not already
   exist using
   `nixos-generate-config --show-hardware-config >  /etc/nixos/hardware-configuration.nix`

4. Edit the default configuration located at `/etc/nixos/configuration.nix` to
   reflect your preferences with `nano`, if no other text editor is present.

5. Build the system with
   `sudo nixos-rebuild switch --flake /etc/nixos# --extra-experimental-features "nix-command flakes"`.
   Subsequent runs can be simplified to `sudo nixos-rebuild switch`.

## Overview

| Category            | Selection                                                                                                                                                          | Rationale                                                                                                                               |
| :------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| Networking          | [NetworkManager](https://www.networkmanager.dev)                                                                                                                   | Simpler to configure and has a wider feature set than wpa_supplicant.                                                                   |
| Security            | [fprint](https://fprint.freedesktop.org/), [GNOME Keyring](https://wiki.gnome.org/Projects/GnomeKeyring), [Hypridle](https://github.com/hyprwm/hypridle)           | Enables fingerprint support, system secret storage, and automatic inactivity locking.                                                   |
| Kernel              | [Linux Kernel](https://kernel.org/) (with [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth))                                                          | Uses latest version with low logging, improved sleep via kernelParams, and a boot animation.                                            |
| Browser             | [Helium](https://helium.computer/)                                                                                                                                 | Privacy-first ethos implemented via [vikingnope's flake](https://github.com/vikingnope/helium-browser-nix-flake) for automated updates. |
| Desktop Environment | [Hyprland](https://hypr.land/), [Stylix](https://nix-community.github.io/stylix/), [Rofi](https://davatorium.github.io/rofi/), [Dunst](https://dunst-project.org/) | A minimal tiling compositor with automated theming, app launching, and notification management.                                         |
| Hardware            | [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq) & fstrim                                                                                               | Handles battery management with simpler configuration than power-profiles-daemon and prolongs SSD lifespan.                             |
| Terminal            | [Ghostty](https://ghostty.org/)                                                                                                                                    | A performant terminal emulator with extensive configurability for CLI-heavy workflows.                                                  |
| Editor              | [Neovim](https://neovim.io/) (via [NVF](https://nvf.notashelf.dev/index.html))                                                                                     | High-extensibility text editing managed through the NVF configuration framework.                                                        |
| Shell               | [Fish](https://fishshell.com/) & [Bash](https://www.gnu.org/software/bash/)                                                                                        | Fish provides a modern user-facing shell, while Bash is retained for system-level compatibility.                                        |
