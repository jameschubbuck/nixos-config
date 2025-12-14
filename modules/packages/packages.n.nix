{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    baobab # Disk usage analyzer
    pavucontrol # Audio control
    thunderbird # Email client
    keepassxc # Password manager
    nautilus # File manager
    gnome-disk-utility # Disk manager
    eog # Image viewer
    qbittorrent #
    ddcutil # sudo ddcutil --bus=16 setvcp 12 [0/100]; ddcutil --bus=16 setvcp 10 [0/100]
    unar # Archive manager
    gimp # Image editor
    bottles # Wine prefix manager
    mangohud # System info viewer
    bolt # Thunderbolt daemon
    blueman # Bluetooth manager
    libnotify # Send notifications
    kitty # Backup terminal
  ];
  services.hardware.bolt.enable = true;
  programs.adb.enable = true;
  services.gvfs.enable = true; # Nautilus trash support
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
}
