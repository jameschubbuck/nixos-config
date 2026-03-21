{pkgs, ...}: {
  # Moved packages to the rofi-menu module. Keep unrelated services here.
  services.mullvad-vpn.enable = true;
}
