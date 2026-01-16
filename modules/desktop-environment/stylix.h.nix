{pkgs, ...}: {
  stylix = {
    targets = {
      rofi.enable = true;
      gtk.enable = true;
      ghostty.enable = true;
      fish.enable = true;
      opencode.enable = false;
      nvf.enable = false;
    };
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
    cursor = {
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
