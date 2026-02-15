{zorrOS, ...}: {
  users.users.${zorrOS.username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "i2c"];
  };
}
