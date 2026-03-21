{
  pkgs,
  zorrOS,
  ...
}: {
  stylix = {
    enable = true;
    image = ./assets/black.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${zorrOS.theme}.yaml";
    targets.plymouth.enable = false;
    fonts = {
      serif = {
        package = pkgs.geist-font;
        name = "Geist Sans";
      };
      sansSerif = {
        package = pkgs.geist-font;
        name = "Geist Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.geist-mono;
        name = "Geist Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
