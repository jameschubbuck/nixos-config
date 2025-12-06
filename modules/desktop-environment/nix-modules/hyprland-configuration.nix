{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = false;
    };
  };
  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
  ];
  environment = {
    systemPackages = with pkgs; [
      brightnessctl
      adwaita-icon-theme
    ];
  };
  programs.bash.loginShellInit = "start-hyprland";
}
