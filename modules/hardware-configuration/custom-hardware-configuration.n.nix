{
  hardware.i2c.enable = true;
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
    #libinput = {
    #  enable = true;
    #  touchpad.disableWhileTyping = false;
    #};
  };
  hardware.graphics = {
    enable = true;
  };
}
