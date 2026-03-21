{ pkgs, ... }:

let
  rofiMenu = pkgs.writeShellScriptBin "rofi-menu" ''
    #!/usr/bin/env bash
    set -euo pipefail

    MENU=$(${pkgs.rofi}/bin/rofi -dmenu -i -p "Launch" <<'EOF'
Passwords
Mail
Games
Web
Terminal
Files
[Special] default
EOF
)

    case "$MENU" in
      "Passwords")
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace pass || true
        exec keepassxc &
        ;;
      "Mail")
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace mail || true
        exec betterbird &
        ;;
      "Games")
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace games || true
        # prefer flatpak Bottles if available
        if command -v ${pkgs.flatpak}/bin/flatpak >/dev/null 2>&1; then
          ${pkgs.flatpak}/bin/flatpak run com.usebottles.bottles &
        else
          exec bottles &
        fi
        ;;
      "Web")
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace web || true
        exec helium &
        ;;
      "Terminal")
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace term || true
        exec ghostty &
        ;;
      "Files")
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace files || true
        exec nautilus &
        ;;
      *)
        exec ${pkgs.rofi}/bin/rofi -show drun
        ;;
    esac
  '';

in {
  environment.systemPackages = with pkgs; [
    rofiMenu
    keepassxc
    qbittorrent
    unar
    ffmpeg
    librepods
    (callPackage ../packages/betterbird.nix {})
    ddcutil
    bluetui
    pulsemixer
    vulkan-loader
    steam-run-free
  ];

  services.flatpak = {
    enable = true;
    packages = [ {
      appId = "com.usebottles.bottles";
      origin = "flathub";
    } ];
  };
}
