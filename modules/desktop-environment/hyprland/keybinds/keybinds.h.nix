{pkgs, ...}: let
  webSearch = pkgs.writeShellScriptBin "web-search" (builtins.readFile ./search);
in {
  home.packages = [pkgs.jq];
  wayland.windowManager.hyprland = {
    settings = let
      baseBinds = [
        "G, exec, ghostty"
        "H, exec, helium --password-store=basic"
        "Super_L, exec, rofi -show drun"
        "TAB, exec, rofi -show window"
        "Q, killactive"
        "F, exec, hyprctl dispatch fullscreenstate 2 0"
        "Escape, exec, hyprlock --no-fade-in"
        "space, exec, ${webSearch}/bin/web-search"
      ];
    in {
      bind = builtins.map (b: ''$mainMod, ${b}'') baseBinds;
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
