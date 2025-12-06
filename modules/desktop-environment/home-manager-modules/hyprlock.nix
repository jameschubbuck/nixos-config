{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      auth = {
        fingerprint = {
          enabled = true;
        };
      };
      general = {
        hide_cursor = true;
      };
    };
  };
}
