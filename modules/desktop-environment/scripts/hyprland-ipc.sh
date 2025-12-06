toggle-fullscreen() {
        hyprctl dispatch fullscreenstate 2 1
}

conditional-fullscreen() {
        workspace=$(hyprctl activeworkspace)
        window_count=$(echo "$workspace" | grep -oP '(?<=windows: )\d+')
        has_fullscreen=$(echo "$workspace" | grep -oP '(?<=hasfullscreen: )\d+')

        if [ "$window_count" -eq 1 ] && [ "$has_fullscreen" -eq 0 ]; then
                toggle-fullscreen
        elif [ "$window_count" -gt 1 ] && [ "$has_fullscreen" -eq 1 ]; then
                toggle-fullscreen
        fi
}

handle() {
        case $1 in
        openwindow*) conditional-fullscreen ;;
        workspacev2*) conditional-fullscreen ;;
        closewindow*) conditional-fullscreen ;;
                # movewindowv2*) conditional-fullscreen ;;
                # changefloatingmode*) conditional-fullscreen ;;
        esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
