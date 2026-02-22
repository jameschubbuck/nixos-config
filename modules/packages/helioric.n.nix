{pkgs, ...}: let
  helioricFlake = builtins.getFlake "github:jameschubbuck/helioric";
in {
  environment.systemPackages = [
    helioricFlake.packages.${pkgs.system}.default
  ];
}
