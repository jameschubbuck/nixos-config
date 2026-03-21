{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unar
    ffmpeg
    librepods
    pkgs.ddcutil
    bluetui
    pulsemixer
    vulkan-loader
    steam-run-free
  ];
  services.mullvad-vpn.enable = true;
  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "com.usebottles.bottles";
        origin = "flathub";
      }
    ];
  };
}
