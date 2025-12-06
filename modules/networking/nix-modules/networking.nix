{lib, ...}: {
  services.resolved.enable = false;
  networking = {
    hostName = "ares";
    hostId = "5a52d4bb";
    networkmanager = {
      enable = true;
      dns = "default";
    };
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 3000 4000 5000];
    };
    hosts = {
      "192.168.0.217" = ["tailwing.local"];
      #"192.168.0.217:4000" = ["backend.tailwing.co"];
      #"192.168.0.217:5000" = ["database.tailwing.co"];
    };
  };
}
