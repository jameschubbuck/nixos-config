{
  pkgs,
  lib,
  ...
}: let
  wallpaper = pkgs.runCommand "black-wallpaper.png" {} ''
    # PNG24: prefix forces 24-bit RGB output, preventing 1-bit grayscale optimization
    ${lib.getExe pkgs.imagemagick} -size 1920x1080 xc:#000000 -colorspace sRGB -type TrueColor -depth 8 PNG24:$out
  '';
in {
  # Write hyprpaper.conf directly using the new 0.8.1 category-based syntax
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    wallpaper {
        monitor = DP-1
        path = ${wallpaper}
        fit_mode = cover
    }
    splash = false
  '';

  # Launch hyprpaper via Hyprland's exec-once
  wayland.windowManager.hyprland.settings.exec-once = [
    "${lib.getExe pkgs.hyprpaper}"
  ];

  home.packages = [
    pkgs.hyprpaper
  ];
}
