{pkgs, ...}: {
  hardware.graphics.enable = true;

  services.fwupd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.power-profiles-daemon.enable = true;

  services.fstrim.enable = true;
}
