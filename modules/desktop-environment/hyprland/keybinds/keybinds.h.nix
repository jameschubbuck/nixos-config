{pkgs, ...}: let
  webSearch = pkgs.writeShellScriptBin "web-search" ''
    export PATH=$PATH:/run/current-system/sw/bin

    QUERY=$(echo "" | rofi -dmenu -p "Search" -no-auto-select)

    if [ -n "$QUERY" ]; then
        URL="https://duckduckgo.com/?q=$QUERY"
        WINDOW_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class | ascii_downcase | contains("helium")) | .address' | head -n 1)

        if [ -n "$WINDOW_ADDR" ] && [ "$WINDOW_ADDR" != "null" ]; then
            helium --password-store=basic "$URL" > /dev/null 2>&1 &
            hyprctl dispatch focuswindow address:"$WINDOW_ADDR"
        else
            helium --password-store=basic "$URL" > /dev/null 2>&1 &
            
            sleep 0.5
            
            NEW_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class | ascii_downcase | contains("helium")) | .address' | head -n 1)
            if [ -n "$NEW_ADDR" ] && [ "$NEW_ADDR" != "null" ]; then
                 hyprctl dispatch focuswindow address:"$NEW_ADDR"
            fi
        fi
    fi
  '';
in {
  home.packages = [pkgs.jq webSearch];
  wayland.windowManager.hyprland = {
    settings = let
      baseBinds = [
        "G, exec, ghostty"
        "H, exec, helium --password-store=basic"
        "Super_L, exec, rofi -show drun"
        "TAB, exec, rofi -show window"
        "Q, killactive"
        "F, exec, hyprctl dispatch fullscreenstate 2 0"
        "Escape, exec, hyprlock --no-fade-in"
        "space, exec, web-search"
      ];
    in {
      bind = builtins.map (b: ''$mainMod, ${b}'') baseBinds;
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
