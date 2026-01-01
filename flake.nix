{
  description = "Personal NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    helium = {
      url = "github:vikingnope/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvf,
    nur,
    stylix,
    hyprland,
    helium,
  } @ inputs: let
    lib = nixpkgs.lib;

    allModuleFiles = lib.filesystem.listFilesRecursive ./modules;

    mkModuleList = type: map import (lib.filter (path: lib.hasInfix type (toString path)) allModuleFiles);

    homeManagerModuleConfigs = mkModuleList ".h.";

    nixosModuleConfigs = mkModuleList ".n.";
  in {
    nixosConfigurations = {
      ares = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          nixosModuleConfigs
          ++ [
            {
              nixpkgs.overlays = [
                (import ./modules/overlays/librepods.nix)
              ];
            }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
                users.james = {
                  imports = homeManagerModuleConfigs;
                };
              };
            }
            nur.modules.nixos.default
            home-manager.nixosModules.home-manager
            nvf.nixosModules.default
            stylix.nixosModules.stylix
          ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
