{lib, ...}: {
  networking = {
    hostName = "ares";
    networkmanager = {
      enable = true;
      dns = "default";
    };
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 3000 4000 5000];
    };
  };
}
