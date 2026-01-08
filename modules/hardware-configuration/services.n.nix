{
  services = {
    fwupd.enable = true;
    auto-cpufreq = {
      # power-profiles-daemon performs very slightly better, but auto-cpufreq can govern itself
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
    mullvad-vpn.enable = true;
  };
}
