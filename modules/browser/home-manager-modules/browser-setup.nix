{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
    };
  };
  stylix.targets.firefox.profileNames = ["default"];
}
