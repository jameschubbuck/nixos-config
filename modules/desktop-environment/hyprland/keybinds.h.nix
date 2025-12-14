{...}: {
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mainMod, G, exec, ghostty"
        "$mainMod, Q, exec, /etc/nixos/modules/desktop-environment/scripts/killactive"
        "$mainMod, F, exec, /etc/nixos/modules/desktop-environment/scripts/toggle-fullscreen"
        "$mainMod, Super_L, exec, /etc/nixos/modules/desktop-environment/scripts/menu.sh"
        "$mainMod, Escape, exec, hyprlock"
        "$mainMod SHIFT, Escape, exec, hyprlock & systemctl suspend"
        "$mainMod, D, exec, /etc/nixos/modules/desktop-environment/scripts/toggle-internal-display"
        "$mainMod, 1, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 1"
        "$mainMod, 2, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 2"
        "$mainMod, 3, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 3"
        "$mainMod, 4, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 4"
        "$mainMod, 5, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 5"
        "$mainMod, 6, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 6"
        "$mainMod, 7, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 7"
        "$mainMod, 8, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 8"
        "$mainMod, 9, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 9"
        "$mainMod, 0, exec, /etc/nixos/modules/desktop-environment/scripts/changetoworkspace 10"
        "$mainMod SHIFT, 1, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 1"
        "$mainMod SHIFT, 2, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 2"
        "$mainMod SHIFT, 3, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 3"
        "$mainMod SHIFT, 4, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 4"
        "$mainMod SHIFT, 5, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 5"
        "$mainMod SHIFT, 6, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 6"
        "$mainMod SHIFT, 7, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 7"
        "$mainMod SHIFT, 8, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 8"
        "$mainMod SHIFT, 9, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 9"
        "$mainMod SHIFT, 0, exec, /etc/nixos/modules/desktop-environment/scripts/movetoworkspace 10"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindl = [
        ",XF86AudioRaiseVolume, exec, /etc/nixos/modules/desktop-environment/scripts/update-audio raise"
        ",XF86AudioLowerVolume, exec, /etc/nixos/modules/desktop-environment/scripts/update-audio lower"
        ",XF86AudioMute, exec, /etc/nixos/modules/desktop-environment/scripts/update-audio toggle"
        #",XF86AudioMicMute, exec, /etc/nixos/modules/desktop-environment/scripts/update-audio toggle"
        ",XF86MonBrightnessUp, exec, /etc/nixos/modules/desktop-environment/scripts/update-brightness raise"
        ",XF86MonBrightnessDown, exec, /etc/nixos/modules/desktop-environment/scripts/update-brightness lower"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
