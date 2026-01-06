{
  pkgs,
  inputs,
  ...
}: let
  hyprland_package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = with pkgs; [
    killall
    brightnessctl
    adwaita-icon-theme
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common = {
        default = ["gtk"];
      };
      hyprland = {
        default = ["gtk" "hyprland"];
      };
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland_package.hyprland;
    portalPackage = hyprland_package.xdg-desktop-portal-hyprland;
    settings = {
      "monitor" = [
        "eDP-1, 2560x1600@165, 0x0,    1.6, cm, auto"
        "DP-9,  1920x1080@144, 2560x0, 1,   cm, auto"
        "DP-1,  1920x1080@144, 2560x0, 1,   cm, auto"
      ];
      "$mainMod" = "SUPER";
      general = {
        "allow_tearing" = "false";
        "layout" = "dwindle";
      };
      misc = {
        "vrr" = "true";
        "vfr" = "true";
        "disable_autoreload" = "true";
        "disable_hyprland_logo" = "true";
        "disable_splash_rendering" = "true";
      };
      debug = {
        "disable_logs" = "true";
      };
      render = {
        "direct_scanout" = "0";
        "cm_fs_passthrough" = "0";
      };
      quirks = {
        "prefer_hdr" = "1";
      };
      xwayland = {
        "enabled" = "true";
        "force_zero_scaling" = "true";
      };
      input = {
        "kb_layout" = "us";
        "follow_mouse" = "1";
        "sensitivity" = "0";
        touchpad = {
          "natural_scroll" = "false";
        };
      };
      cursor = {
        "hide_on_key_press" = "true";
        "inactive_timeout" = "1";
      };
      ecosystem = {
        "no_update_news" = "true";
        "no_donation_nag" = "true";
      };
    };
  };
}
