{
  description = "ZorrOS configuration";
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
    helioric = {
      url = "github:jameschubbuck/helioric";
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
    helioric,
  } @ inputs: let
    lib = nixpkgs.lib;
    zorrOS = import ./zorros.nix;
    moduleFiles = lib.filesystem.listFilesRecursive ./modules;
    modules = type: map import (lib.filter (path: lib.hasInfix type (toString path)) moduleFiles);
    homeManagerModuleConfigs = modules ".h.";
    nixosModuleConfigs = modules ".n.";
  in {
    nixosConfigurations = {
      ares = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs zorrOS;};
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
                extraSpecialArgs = {inherit inputs zorrOS;};
                users.${zorrOS.username} = {
                  imports = homeManagerModuleConfigs;
                };
              };
            }
            nur.modules.nixos.default
            home-manager.nixosModules.home-manager
            nvf.nixosModules.default
            stylix.nixosModules.stylix
          ];
      };
    };
  };
}
