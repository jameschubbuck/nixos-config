{pkgs, ...}: let
  disableInternalMonitorOnStartup = pkgs.writeShellScriptBin "disable-internal-on-startup" ''
    INTERNAL_DISPLAY="eDP-1"
    MONITOR_COUNT=$(hyprctl monitors | ${pkgs.gnugrep}/bin/grep -c "^Monitor")
    if [ "$MONITOR_COUNT" -gt 1 ]; then
        hyprctl keyword monitor "$INTERNAL_DISPLAY, disable"
    fi
  '';
in {
  wayland.windowManager.hyprland.settings.exec-once = [
    "${disableInternalMonitorOnStartup}/bin/disable-internal-on-startup"
  ];
}
