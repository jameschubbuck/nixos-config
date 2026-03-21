{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = ""; # Don't auto-start; launcher controls visibility
    settings = {
      workspaceIndicator = {
        layer = "top"; # BOTTOM!
        position = "bottom";
        exclusive = false;
        passthrough = true;
        modules-left = ["clock"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["battery"];
        "hyprland/workspaces" = {
          active-only = true;
          show-special = true;
          format = "{name}";
        };
        "clock" = {
          format = "{:%H:%M:%S}";
          interval = 1;
        };
        "battery" = {
          bat = "BAT1";
          interval = 2;
          format = "{capacity}% ({power:.0f}W)";
        };
      };
    };
    style = ''
      * {
        font-size: 16px;
        border: none;
        border-radius: 0;
        box-shadow: none;
        outline: none;
        text-shadow: none;
        transition-duration: 0s;
      }
      window#waybar {
        background-color: transparent;
        color: white;
      }
      #workspaces {
        margin: 0 5px;
      }
      #workspaces button {
        padding: 0 11px;
        background: transparent;
      }
      #workspaces button.active,
      #workspaces button.focused,
      #workspaces button.visible,
      #workspaces button:hover {
        background: transparent;
        color: white;
        border: none;
        box-shadow: none;
      }
      #clock {
        margin: 0 15px;
      }
      #battery {
        padding: 0 15px;
      }
    '';
  };
}
