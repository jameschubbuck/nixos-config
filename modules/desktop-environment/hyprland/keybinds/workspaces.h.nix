{pkgs, ...}: let
  workspace-script = pkgs.writeShellScript "hypr-workspace-op" ''
    operation="$1"
    ws_num="$2"
    if ! ${pkgs.hyprland}/bin/hyprctl layers | ${pkgs.gnugrep}/bin/grep -q "rofi"; then
      if [ "$operation" = "move" ]; then
        ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace "$ws_num"
      elif [ "$operation" = "change" ]; then
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace "$ws_num"
        
        # Auto-fullscreen if only one window on the new workspace
        window_count=$(${pkgs.hyprland}/bin/hyprctl -j clients | ${pkgs.jq}/bin/jq --arg ws "$ws_num" '[.[] | select(.workspace.id == ($ws | tonumber))] | length')
        if [ "$window_count" = "1" ]; then
          is_fullscreen=$(${pkgs.hyprland}/bin/hyprctl -j clients | ${pkgs.jq}/bin/jq -r --arg ws "$ws_num" '.[] | select(.workspace.id == ($ws | tonumber)) | .fullscreen')
          if [ "$is_fullscreen" = "0" ]; then
            ${pkgs.hyprland}/bin/hyprctl dispatch fullscreenstate 2 0
          fi
        fi
      fi
    fi
  '';
in {
  home.packages = [ pkgs.jq ];
  wayland.windowManager.hyprland = {
    settings = {
      bind =
        (
          builtins.concatLists (
            builtins.genList
            (
              i: let
                ws = i + 1;
                ws_key = toString ws;
              in [
                "\$mainMod, ${ws_key}, exec, ${workspace-script} change ${ws_key}"

                "\$mainMod SHIFT, ${ws_key}, exec, ${workspace-script} move ${ws_key}"
              ]
            )
            9
          )
        )
        ++ [
          "$mainMod, 0, exec, ${workspace-script} change 10"
          "$mainMod SHIFT, 0, exec, ${workspace-script} move 10"
        ];
    };
  };
}
