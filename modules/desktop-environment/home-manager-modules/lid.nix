{pkgs, ...}: let
  lidClosed = pkgs.writeShellScript "lidClosed" ''
    if [ $(wlr-randr | grep -v '^[[:space:]]' | wc -l) -ne 1 ]; then
      hyprctl keyword monitor "eDP-1, disable"
    else
      hyprlock & systemctl hibernate
    fi
  '';
  lidOpened = pkgs.writeShellScript "lidOpened" ''
    if [ $(wlr-randr | grep -v '^[[:space:]]' | wc -l) -eq 1 ]; then
      hyprctl keyword monitor 'eDP-1, 2560x1600@165, 0x0, 1.6'
    fi
  '';
in {
  home.packages = [pkgs.wlr-randr];
  wayland.windowManager.hyprland.settings.bindl = [
    ", switch:on:Lid Switch, exec, ${lidClosed}"
    ", switch:off:Lid Switch, exec, ${lidOpened}"
  ];
}
