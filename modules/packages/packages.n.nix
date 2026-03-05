{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    keepassxc # Password manager
    qbittorrent #
    unar # Archive manager
    gimp # Image editor
    (bottles.override {removeWarningPopup = true;}) # Wine prefix manager
    mangohud # System info viewer
    bc # Basic calculator
    mpv # Media player
    ffmpeg
    librepods
    kdePackages.qtstyleplugin-kvantum # Dependency for librepods styling
    android-tools
    blender
    super-slicer
    (callPackage ./betterbird.nix {})
    pkgs.ddcutil
    zotero
    bluetui
    pulsemixer
  ];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.mullvad-vpn.enable = true;
  programs.fuse.userAllowOther = true;
  hardware.i2c.enable = true;
}
