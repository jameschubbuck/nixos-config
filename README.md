# NixOS Configuration

## Structure

Modules are structured with an emphasis on portability and scalability. Any
module should be able to be imported into any other NixOS configuration and
function as intended. To do this, individual modules are arranged in the flat
directory `/modules`. Each module is kebab-cased and contains code
related either to a specific tool or task. For example, `/modules/hyprland`
contains configuration options related to Hyprland, while
`/modules/hardware-configuration` relates to hardware configuration. Each module
may contain `nix-modules` and/or `home-manager-modules`, which can contain any
number of nix modules that are automatically imported by the flake.
Any related assets, such as images or scripts, are located at `./assets` inside
of the module.
