{pkgs, ...}: let
  batteryMonitor = pkgs.writeShellScriptBin "battery-monitor" ''
    while true; do
      current=$(cat /sys/class/power_supply/BAT1/current_now)
      voltage=$(cat /sys/class/power_supply/BAT1/voltage_now)
      charge_now=$(cat /sys/class/power_supply/BAT1/charge_now)
      charge_full=$(cat /sys/class/power_supply/BAT1/charge_full)

      power_draw=$(echo "scale=2; $current / 1000000 * $voltage / 1000000" | ${pkgs.bc}/bin/bc)

      if [ "$charge_full" -ne 0 ]; then
        battery_percentage=$(echo "scale=2; $charge_now / $charge_full * 100" | ${pkgs.bc}/bin/bc)
      else
        battery_percentage=0
      fi

      total_energy=$(echo "scale=2; $charge_full / 1000000 * $voltage / 1000000" | ${pkgs.bc}/bin/bc)

      printf "\r\e[32mCurrent Power Draw: %.2f W | Battery Percentage: %.2f %% | Total Energy: %.2f Wh\e[0m" \
        "$power_draw" "$battery_percentage" "$total_energy"

      sleep 1
    done
  '';
  
  librepodsScript = pkgs.writeShellScriptBin "librepods" ''
    ${pkgs.waybar}/bin/waybar | while read -r line; do
      echo "$line"
      if echo "$line" | ${pkgs.gnugrep}/bin/grep -q "Bar configured"; then
        ${pkgs.librepods}/bin/librepods
        ${pkgs.procps}/bin/pkill -f waybar
        break
      fi
    done
  '';
in {
  home.packages = with pkgs; [
    lsd
    tree
    grc
    ripgrep
    wl-clipboard-rs
    waybar
    batteryMonitor
    librepodsScript
  ];
  programs = {
    fish = {
      enable = true;
      generateCompletions = true;
      interactiveShellInit = ''
        set -g fish_greeting ""
        bind \t forward-char
        bind \e\[C complete
      '';
      plugins = [
        {
          name = "transient-fish";
          src = pkgs.fishPlugins.transient-fish.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "sudope";
          src = pkgs.fishPlugins.plugin-sudope.src;
        }
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
      ];
      shellAliases = {
        "v" = "vi";
        "ls" = "lsd --group-directories-first --ignore-glob='__pycache__' --ignore-glob='*.lock'";
        "tree" = "tree -I '__pycache__|*.lock'";
        "nix-shell" = "nix-shell --command 'fish'";
        "librepods" = "librepods";
        "oc" = "opencode";
        "logout" = "loginctl terminate-user $USER";
      };
      functions = {
        c = {
          body = ''
            cat $argv | wl-copy
          '';
        };
      };
    };
  };
}
