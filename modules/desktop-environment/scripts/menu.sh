workspace=$(hyprctl activeworkspace)
has_fullscreen=$(echo "$workspace" | grep -oP '(?<=hasfullscreen: )\d+')
monitor=$(echo "$workspace" | grep -oP '(?<=on monitor )\S+(?=:)')

toggle-fullscreen() {
        if [ "$has_fullscreen" -eq 1 ]; then
                hyprctl dispatch fullscreenstate 2 0
        fi
}

toggle-waybar() {
        pkill -SIGUSR1 waybar
}

reserve-space() {
        hyprctl keyword monitor "$monitor, addreserved, 37, 0, 0, 0"
}

show-rofi() {
        rofi -show drun
}

free-space() {
        hyprctl keyword monitor "$monitor, addreserved, 0, 0, 0, 0"
}

lock-menu() {
        echo 1 >/tmp/menu.lock
}

free-menu() {
        echo 0 >/tmp/menu.lock
}

if [ $(cat /tmp/menu.lock) -ne 1 ]; then
        lock-menu
        toggle-fullscreen
        #toggle-waybar
        #reserve-space
        show-rofi
        #free-space
        #toggle-waybar
        toggle-fullscreen
fi

free-menu
