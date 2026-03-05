{pkgs, ...}: let
  update-audio-script = pkgs.writeShellScriptBin "update-audio" ''
    set -euo pipefail

    readonly VOLUME_STEP="10%"
    readonly MAX_VOLUME="1"
    readonly NOTIFY_TIMEOUT=2000
    readonly NOTIFY_ID=9911
    readonly NOTIFY_TITLE="Volume"

    get_default_sink_id() {
        wpctl status | ${pkgs.gawk}/bin/awk '
            /├─ Sinks:/, /Sources:/ {
                if (match($0, /\*\s*([0-9]+)\./, M)) {
                    print M[1]
                }
            }
        ' | head -n 1
    }

    get_sink_status() {
        local sink_id="$1"
        wpctl get-volume "$sink_id" | sed 's/[Vv]olume: \([0-9.]\+\)\( \[MUTED\]\)\?/\1 \2/'
    }

    notify_volume_status() {
        local sink_id="$1"
        local status
        status=$(get_sink_status "$sink_id")
        local volume
        local is_muted
        volume=$(echo "$status" | ${pkgs.gawk}/bin/awk '{print $1}')
        is_muted=$(echo "$status" | ${pkgs.gnugrep}/bin/grep -q '\[MUTED\]' && echo true || echo false)
        local volume_percent
        volume_percent=$(printf "%.0f" "$(echo "$volume * 100" | ${pkgs.bc}/bin/bc)")
        local message
        if $is_muted; then
            message="Muted"
        else
            message="''${volume_percent}%"
        fi
        ${pkgs.libnotify}/bin/notify-send \
            --urgency=low \
            --expire-time="$NOTIFY_TIMEOUT" \
            --replace-id="$NOTIFY_ID" \
            "$NOTIFY_TITLE" \
            "$message"
    }

    readonly DEFAULT_SINK="$(get_default_sink_id)"

    case "''${1:-}" in
    toggle)
        wpctl set-mute "$DEFAULT_SINK" toggle
        notify_volume_status "$DEFAULT_SINK"
        ;;
    raise)
        wpctl set-volume -l "$MAX_VOLUME" "$DEFAULT_SINK" "$VOLUME_STEP"+
        notify_volume_status "$DEFAULT_SINK"
        ;;
    lower)
        wpctl set-volume -l "$MAX_VOLUME" "$DEFAULT_SINK" "$VOLUME_STEP"-
        notify_volume_status "$DEFAULT_SINK"
        ;;
    *)
        echo "Usage: $0 {toggle|raise|lower}" >&2
        exit 1
        ;;
    esac
  '';
  switch-sink-script = pkgs.writeShellScriptBin "switch-sink" ''
    set -euo pipefail

    readonly NOTIFY_TIMEOUT=2000
    readonly NOTIFY_ID=9912
    readonly NOTIFY_TITLE="Audio Output"

    sinks=$(${pkgs.wireplumber}/bin/wpctl status | ${pkgs.gawk}/bin/awk '
        /├─ Sinks:/, /Sources:/ {
            if (match($0, /(\*?)\s*([0-9]+)\.\s*(.+)$/, M)) {
                print M[2] ":" M[1] ":" M[3]
            }
        }
    ' | head -n -1)

    sink_ids=()
    sink_names=()
    current_idx=0

    while IFS=: read -r id is_active name; do
        sink_ids+=("$id")
        sink_names+=("$name")
        if [[ -n "$is_active" ]]; then
            current_idx=$((''${#sink_ids[@]} - 1))
        fi
    done <<< "$sinks"

    if [[ ''${#sink_ids[@]} -eq 0 ]]; then
        ${pkgs.libnotify}/bin/notify-send --urgency=critical "No audio sinks found"
        exit 1
    fi

    next_idx=$(( (current_idx + 1) % ''${#sink_ids[@]} ))
    next_sink=''${sink_ids[$next_idx]}
    next_name=''${sink_names[$next_idx]}

    ${pkgs.wireplumber}/bin/wpctl set-default "$next_sink"

    ${pkgs.libnotify}/bin/notify-send \
        --urgency=low \
        --expire-time="$NOTIFY_TIMEOUT" \
        --replace-id="$NOTIFY_ID" \
        "$NOTIFY_TITLE" \
        "Switched to: $next_name"
  '';
in {
  home.packages = with pkgs; [
    pipewire
    wireplumber
    libnotify
    gnugrep
    bc
    gawk
    coreutils
    gnused
    update-audio-script
    switch-sink-script
  ];
  wayland.windowManager.hyprland.settings.bindl = [
    ",XF86AudioRaiseVolume, exec, ${update-audio-script}/bin/update-audio raise"
    ",XF86AudioLowerVolume, exec, ${update-audio-script}/bin/update-audio lower"
    ",XF86AudioMute, exec, ${update-audio-script}/bin/update-audio toggle"
    ",XF86AudioCycle, exec, ${switch-sink-script}/bin/switch-sink"
  ];
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, comma, exec, ${switch-sink-script}/bin/switch-sink"
  ];
}
