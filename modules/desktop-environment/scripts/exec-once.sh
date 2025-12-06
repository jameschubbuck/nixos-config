update_monitors() {
        if hyprctl monitors | grep -q "DP-9"; then
                hyprctl keyword monitor "eDP-1, disable"
        fi
}

(
        update_monitors &
        hyprlock
)
