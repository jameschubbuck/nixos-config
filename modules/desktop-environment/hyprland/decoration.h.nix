{
  zorrOS,
  config,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        "gaps_in" = zorrOS.padding;
        "gaps_out" = zorrOS.padding;
        "border_size" = "0";
        "col.active_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base03})";
        "col.inactive_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base03})";
      };
      decoration = {
        "rounding" = zorrOS.padding;
        shadow = {
          "enabled" = "false";
        };
        blur = {
          "enabled" = "false";
        };
      };
      animations = {
        "enabled" = "false";
        "animation" = "global, 1, 2, default";
      };
      misc = {
        "force_default_wallpaper" = "0";
      };
    };
  };
}
