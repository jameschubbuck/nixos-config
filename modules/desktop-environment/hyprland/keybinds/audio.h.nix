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
in {
  home.packages = with pkgs; [
    pipewire
    libnotify
    gnugrep
    bc
    gawk
    coreutils
    gnused
    update-audio-script
  ];
  wayland.windowManager.hyprland.settings.bindl = [
    ",XF86AudioRaiseVolume, exec, ${update-audio-script}/bin/update-audio raise"
    ",XF86AudioLowerVolume, exec, ${update-audio-script}/bin/update-audio lower"
    ",XF86AudioMute, exec, ${update-audio-script}/bin/update-audio toggle"
  ];
}
