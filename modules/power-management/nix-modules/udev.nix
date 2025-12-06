{ pkgs, ... }: {
  services.udev = {
    enable = true;
    extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.writeShellScript "plugged" ''
        log="/tmp/udev.log"
        if [ ! -f $log ] || [ "$(cat $log)" != "PLUGGED" ]; then
          echo "PLUGGED" > $log
          for i in {1..12}; do echo 1 | sudo tee /sys/devices/system/cpu/cpu''${i}/online; done
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action --disable amdgpu_panel_power
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action --disable amdgpu_dpm
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
        fi
      ''}'"
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.writeShellScript "unplugged" ''
        log="/tmp/udev.log"
        if [ -f $log ] && [ "$(cat $log)" != "UNPLUGGED" ]; then
          echo "UNPLUGGED" > $log
          for i in {1..12}; do echo 0 | sudo tee /sys/devices/system/cpu/cpu''${i}/online; done
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action --enable amdgpu_panel_power
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action --enable amdgpu_dpm
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver 
        fi
      ''}'"
    '';
  };
}

