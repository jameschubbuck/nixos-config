{
  pkgs,
  lib,
  ...
}: let
  scheme = "gruvbox-dark-soft";
  theme = "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
  wallpaper = pkgs.runCommand "image.png" {} ''
    COLOR=$(${lib.getExe pkgs.yq} -r .palette.base01 ${theme})
    ${lib.getExe pkgs.imagemagick} -size 1920x1080 xc:$COLOR $out
  '';
in {
  stylix = {
    enable = true;
    image = wallpaper;
    base16Scheme = theme;
  };
}
