{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          FastConnectable = true;
          ReconnectAttempts = 3;
          ReconnectIntervals = "1 2 4 8 16 32 64";
          ControllerMode = "bredr";
        };
      };
    };
  };
}
