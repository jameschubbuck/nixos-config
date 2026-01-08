{pkgs, ...}: {
  home.packages = [
    pkgs.hyprlock
  ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      animations = {
        enabled = false;
      };
      auth = {
        fingerprint = {
          enabled = true;
        };
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 60;
          on-timeout = "hyprlock";
        }
      ];
    };
  };
}
