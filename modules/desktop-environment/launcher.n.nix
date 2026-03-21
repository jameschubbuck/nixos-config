{
  pkgs,
  inputs,
  ...
}: let
  betterbirdPkg = pkgs.callPackage ../packages/betterbird.nix {};
  heliumPkg = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

  heliumWrapped = pkgs.writeShellScriptBin "helium" ''
    exec "${heliumPkg}/bin/helium" --password-store=basic "$@"
  '';

  entries = [
    {
      key = "t";
      icon = "";
      exec = "${pkgs.ghostty}/bin/ghostty";
      class = "com.mitchellh.ghostty";
      workspace = "terminal";
    }
    {
      key = "m";
      icon = "󰇮";
      exec = "${betterbirdPkg}/bin/betterbird";
      class = "eu.betterbird.Betterbird";
      workspace = "mail";
    }
    {
      key = "p";
      icon = "󰌋";
      exec = "${pkgs.keepassxc}/bin/keepassxc";
      class = "org.keepassxc.KeePassXC";
      workspace = "passwords";
    }
    {
      key = "w";
      icon = "󰖟";
      exec = "${heliumWrapped}/bin/helium";
      class = "helium";
      workspace = "web";
    }
    {
      key = "f";
      icon = "󰉋";
      exec = "${pkgs.nautilus}/bin/nautilus";
      class = "org.gnome.Nautilus";
      workspace = "files";
    }
    {
      key = "g";
      icon = "󰊗";
      exec = "flatpak run com.usebottles.bottles";
      class = "com.usebottles.bottles";
      workspace = "games";
    }
    {
      key = "q";
      icon = "󰅢";
      exec = "${pkgs.qbittorrent}/bin/qbittorrent";
      class = "org.qbittorrent.qBittorrent";
      workspace = "torrent";
    }
  ];

  # Added the Search icon/key here
  menuItems = builtins.concatStringsSep "\\n" (["󱗼 d" "󰍉 s"] ++ map (e: "${e.icon} ${e.key}") entries);

  caseBranches = builtins.concatStringsSep "\n" (map (
      e: ''
        "${e.icon} ${e.key}") launch "${e.workspace}" "${e.class}" "${e.exec}" ;;''
    )
    entries);

  launcher = pkgs.writeShellScriptBin "launcher" ''
    #!/bin/sh
    set -eu
    HYPRCTL="${pkgs.hyprland}/bin/hyprctl"
    JQ="${pkgs.jq}/bin/jq"
    ROFI="${pkgs.rofi}/bin/rofi"
    GREP="${pkgs.gnugrep}/bin/grep"
    SYSTEMCTL="${pkgs.systemd}/bin/systemctl"

    # Check if waybar is currently running
    waybar_is_running() {
      "$SYSTEMCTL" --user is-active --quiet waybar.service
    }

    # Show waybar only if it's not already running
    show_waybar() {
      if ! waybar_is_running; then
        "$SYSTEMCTL" --user start waybar.service
      fi
    }

    # Hide waybar only if it's currently running
    hide_waybar() {
      if waybar_is_running; then
        "$SYSTEMCTL" --user stop waybar.service
      fi
    }

    launch() {
      ws="$1"; class="$2"; cmd="$3"
      hide_waybar
      "$HYPRCTL" dispatch workspace "name:$ws" >/dev/null
      if ! "$HYPRCTL" -j clients 2>/dev/null | "$JQ" -e ".[] | select(.class == \"$class\")" >/dev/null 2>&1; then
        "$HYPRCTL" dispatch exec "$cmd" >/dev/null
      fi
      exit 0
    }

    # Move to the home workspace first, then show waybar for the menu
    # "|| true" prevents hyprctl failures from exiting the script under set -e
    "$HYPRCTL" dispatch workspace "name:home" >/dev/null || true
    show_waybar

    CHOICE=$(printf '${menuItems}\n' | "$ROFI" -dmenu -i -auto-select) || { hide_waybar; exit 0; }

    case "$CHOICE" in
      "󱗼 d") hide_waybar; exec "$ROFI" -show drun ;;

      # --- New Search Logic ---
      "󰍉 s")
        QUERY=$(printf "" | "$ROFI" -dmenu -p "Search web")
        if [ -n "$QUERY" ]; then

          # Check if a bang is used (e.g., !w, !yt).
          # Matches an exclamation mark followed by at least one alphanumeric character.
          if ! printf "%s\n" "$QUERY" | "$GREP" -qE '![A-Za-z0-9]+'; then
            QUERY="!ddg $QUERY"
          fi

          # Encode the query for a URL (simple space to + conversion)
          ENCODED_QUERY=$(echo "$QUERY" | tr ' ' '+')
          SEARCH_URL="https://unduck.link?q=$ENCODED_QUERY"

          # Use your standard check logic:
          # If browser isn't open, launch it with the URL.
          # If it IS open, we still run the command (most browsers will just open a new tab).
          hide_waybar
          "$HYPRCTL" dispatch workspace "name:web" >/dev/null

          if ! "$HYPRCTL" -j clients 2>/dev/null | "$JQ" -e '.[] | select(.class == "helium")' >/dev/null 2>&1; then
            "$HYPRCTL" dispatch exec "${heliumWrapped}/bin/helium $SEARCH_URL" >/dev/null
          else
            # Browser is already open, just send the URL to the binary to open a new tab
            "${heliumWrapped}/bin/helium" "$SEARCH_URL" &
          fi
        else
          hide_waybar
        fi
        exit 0
        ;;
      # ------------------------

      ${caseBranches}
      *) hide_waybar; exit 0 ;;
    esac
  '';
in {
  environment.systemPackages = [
    launcher
    heliumWrapped
    betterbirdPkg
    pkgs.keepassxc
    pkgs.qbittorrent
    pkgs.nautilus
  ];
}
