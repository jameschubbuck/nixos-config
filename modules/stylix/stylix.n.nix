{
  pkgs,
  lib,
  ...
}: let
  scheme = "catppuccin-macchiato";
  theme = "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
  wallpaper = pkgs.runCommand "image.png" {} ''
    ${lib.getExe pkgs.imagemagick} -size 1920x1080 xc:#000000 $out
  '';
in {
  stylix = {
    enable = true;
    # image = wallpaper;
    base16Scheme = theme;
  };
}
