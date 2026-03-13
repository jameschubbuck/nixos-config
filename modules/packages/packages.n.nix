{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    keepassxc
    qbittorrent
    unar
    (bottles.override {removeWarningPopup = true;})
    ffmpeg
    librepods
    (callPackage ./betterbird.nix {})
    pkgs.ddcutil
    zotero
    bluetui
    pulsemixer
  ];
  services.mullvad-vpn.enable = true;
}
