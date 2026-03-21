{
  wayland.windowManager.hyprland = {
    settings = let
      baseBinds = [
        "G, exec, ghostty"
        "H, exec, helium"
        "Super_L, exec, launcher"
        "Q, killactive"
        "F, exec, hyprctl dispatch fullscreenstate 2 0"
        "Escape, exec, hyprlock --no-fade-in"
      ];
    in {
      bind = builtins.map (b: ''$mainMod, ${b}'') baseBinds;
    };
  };
}
