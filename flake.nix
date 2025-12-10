{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
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
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
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
    nixFilesInDir = dir: let
      entries = builtins.attrNames (builtins.readDir dir);
      paths = map (name: "${dir}/${name}") entries;
    in
      lib.filter (path: lib.hasSuffix ".nix" path) paths;
    allModuleFiles = lib.concatMap (
      sub: let
        base = ./modules/${sub};
        dirs = lib.filter (d: builtins.pathExists d) [
          "${base}/nix-modules"
          "${base}/home-manager-modules"
        ];
      in
        lib.concatMap nixFilesInDir dirs
    ) (builtins.attrNames (builtins.readDir ./modules));
    nixosModuleConfigs =
      map import (lib.filter (path: lib.hasInfix "/nix-modules/" path) allModuleFiles);
    homeManagerModuleConfigs =
      map import (lib.filter (path: lib.hasInfix "/home-manager-modules/" path) allModuleFiles);
  in {
    nixosConfigurations = {
      ares = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          nixosModuleConfigs
          ++ [
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
