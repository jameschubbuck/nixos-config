{
  services = {
    fwupd.enable = true;
    auto-cpufreq = {
      enable = false;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    fstrim.enable = true;
    services.libinput = {
      enable = true;
      touchpad.disableWhileTyping = false;
    };
  };
}
