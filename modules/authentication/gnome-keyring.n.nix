{pkgs, ...}: {
  services = {
    gnome.gnome-keyring.enable = true;
    dbus.packages = with pkgs; [
      gnome-keyring
      gcr # GNOME crypto services
    ];
    xserver.displayManager.sessionCommands = ''
      eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
      export SSH_AUTH_SOCK
    '';
  };
  programs.seahorse.enable = true; # GNOME keyring GUI
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };
}
