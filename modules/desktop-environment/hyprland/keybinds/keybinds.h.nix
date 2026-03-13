{
  wayland.windowManager.hyprland = {
    settings = let
      baseBinds = [
        "G, exec, ghostty"
        "H, exec, helium --password-store=basic"
        "Super_L, exec, vicinae toggle"
        "Q, killactive"
        "F, exec, hyprctl dispatch fullscreenstate 2 0"
        "Escape, exec, hyprlock --no-fade-in"
      ];
    in {
      bind = builtins.map (b: ''$mainMod, ${b}'') baseBinds;
    };
  };
}
