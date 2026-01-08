{
  pkgs,
  lib,
  ...
}: let
  wallpaper = pkgs.runCommand "black-wallpaper.png" {} ''
    ${lib.getExe pkgs.imagemagick} -size 1920x1080 xc:#000000 -colorspace sRGB -type TrueColor -depth 8 PNG24:$out
  '';
in {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    wallpaper = ,${wallpaper}
    splash = false
  '';

  wayland.windowManager.hyprland.settings.exec-once = [
    "${lib.getExe pkgs.hyprpaper}"
  ];

  home.packages = [
    pkgs.hyprpaper
  ];
}
