{pkgs, inputs, ...}: {
  environment.systemPackages = [
    inputs.helioric.packages.${pkgs.system}.default
  ];
}
