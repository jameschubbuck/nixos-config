{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    killall
    brightnessctl
    adwaita-icon-theme
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = {
      "exec-once" = "/etc/nixos/modules/desktop-environment/scripts/exec-once.sh";
      "$menu" = "/etc/nixos/modules/desktop-environment/scripts/menu.sh";
      "$toggle-fullscreen" = "/etc/nixos/modules/desktop-environment/scripts/toggle-fullscreen";
      #"monitor" = ",highrr,auto,auto";
      "monitor" = ["eDP-1,2560x1600@165,0x0,1" "DP-9,1920x1080@144,2560x0,1"];
      "$mainMod" = "SUPER";
      general = {
        "allow_tearing" = "false";
        "layout" = "dwindle";
      };
      misc = {
        "vrr" = "true";
        "vfr" = "true";
        "disable_autoreload" = "true";
      };
      debug = {
        "disable_logs" = "true";
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
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
