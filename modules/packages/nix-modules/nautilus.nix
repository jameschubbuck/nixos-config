{pkgs, ...}: {
  # [Gnome Files](https://apps.gnome.org/Nautilus)
  environment.systemPackages = [pkgs.nautilus];
  # Support trash locations with [GVFs](https://nixos.wiki/wiki/Nautilus#GVfs)
  services.gvfs.enable = true;
}
