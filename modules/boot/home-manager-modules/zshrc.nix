{lib, ...}: {
  programs.zsh.initContent = lib.mkOrder 1500 ''
    if uwsm check may-start; then
      exec uwsm start hyprland-uwsm.desktop
    fi
  '';
}
