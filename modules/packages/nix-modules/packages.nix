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
    gnome-disk-utility
    eog
    qbittorrent
    ddcutil # sudo ddcutil --bus=16 setvcp 12 [0/100]; ddcutil --bus=16 setvcp 10 [0/100]
    lutris
    winetricks
    wineWowPackages.waylandFull
    unar
    scrcpy
    android-tools
    mangohud
    nvtopPackages.v3d
    gimp
    bottles
    bolt
  ];
  services.hardware.bolt.enable = true;
  programs.adb.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
}
