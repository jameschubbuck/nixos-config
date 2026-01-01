{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    baobab # Disk usage analyzer
    pavucontrol # Audio control
    thunderbird # Email client
    keepassxc # Password manager
    nautilus # File manager
    gnome-disk-utility # Disk manager
    eog # Image viewer
    qbittorrent #
    unar # Archive manager
    gimp # Image editor
    bottles # Wine prefix manager
    mangohud # System info viewer
    libnotify # Send notifications
    inkscape # Vector editor
    geary # Gnome email
    bc # Basic calculator
    adwaita-icon-theme # Icon
    mpv
    vlc
    ffmpeg
    prismlauncher
    librepods
  ];
  programs.adb.enable = true;
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.gvfs.enable = true; # Nautilus trash support
  # librepods path stuff
  systemd.tmpfiles.rules = [
    "A+ /var/lib/bluetooth - - - - u:james:rx"
  ];
}
