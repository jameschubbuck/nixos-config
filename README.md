<p align="center"><img align="center" src="logo.png" width="370px"></p>

## Structural Overview

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

## Specific Choices

- <h3>Networking</h3>

[NetworkManager](https://www.networkmanager.dev) was chosen over the default
[wpa_supplicant](https://w1.fi/wpa_supplicant/) as it is both simpler to
configure and has a wider feature set.

- <h3>Security</h3>

Fingerprint support is enabled via [fprint](https://fprint.freedesktop.org/).
Additionally [GNOME Keyring](https://wiki.gnome.org/Projects/GnomeKeyring) has
been enabled to support applications which rely on a system keyring.
[Hypridle](https://github.com/hyprwm/hypridle) locks the device automatically
after inactivity.

- <h3>Kernel</h3>

The latest version of the [Linux kernel](https://kernel.org/) is used with low
logging levels and improved sleep support via kernelParams. Additionally, a boot
animation has been enabled via
[Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth).

- <h3>Browser</h3>

[Helium](https://helium.computer/) was selected for its privacy-first ethos and
feature set. It's implemented with [vikingnope](https://github.com/vikingnope)'s
[flake](https://github.com/vikingnope/helium-browser-nix-flake), which receives
automated updates.

- <h3>Desktop Environment</h3>

The desktop environment is implemented with a minimal
[Hyprland](https://hypr.land/) configuration. Theming is provided by
[Stylix](https://nix-community.github.io/stylix/) and app launching is provided
by [Rofi](https://davatorium.github.io/rofi/). Notifications are managed by
[Dunst](https://dunst-project.org/)

- <h3>Additional Hardware Configuration</h3>

Battery management is handled by
[auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq). This performs
similarly to
[power-profiles-daemon](https://gitlab.freedesktop.org/upower/power-profiles-daemon),
however is simpler to configure. `fstrim` is enabled to periodically trim
mounted SSD partitions to prolong hardware lifespans.

- <h3>Terminal</h3>

The majority of development happens in the CLI. [Ghostty](https://ghostty.org/)
provides a performant terminal emulator with extensive configurability. Text
editing is handled with [Neovim](https://neovim.io/), and Neovim configuration
is handled by [NVF](https://nvf.notashelf.dev/index.html).
[Fish](https://fishshell.com/) was chosen as the user-facing shell because it is
highly configurable without a noticeable performance sacrifice. For
compatibility purposes, all system-level operations still utilize
[Bash](https://www.gnu.org/software/bash/).
