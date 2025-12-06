{pkgs, ...}: {
  services.udiskie = {
    enable = false;
    settings = {
      program_options = {
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };
}
