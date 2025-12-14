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

    # Function to recursively find all files in a directory
    recursivelyFindFiles = dir:
      lib.flatten (
        lib.mapAttrsToList
        (
          name: type: let
            path = "${dir}/${name}";
          in
            if type == "directory"
            then
              # Recursively call for directories
              recursivelyFindFiles path
            else if type == "regular"
            then
              # Return path for regular files
              [path]
            else
              # Ignore other types (symlinks, etc.)
              []
        )
        (builtins.readDir dir)
      );

    # 1. Get ALL files recursively under ./modules
    allModuleFiles = recursivelyFindFiles ./modules;

    # 2. Filter for NixOS modules (.n.nix)
    nixosModulePaths = lib.filter (path: lib.hasSuffix ".n.nix" path) allModuleFiles;
    nixosModuleConfigs = map import nixosModulePaths;

    # 3. Filter for Home Manager modules (.h.nix)
    homeManagerModulePaths = lib.filter (path: lib.hasSuffix ".h.nix" path) allModuleFiles;
    homeManagerModuleConfigs = map import homeManagerModulePaths;
  in {
    nixosConfigurations = {
      ares = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          nixosModuleConfigs
          ++ [
            # Include your NixOS configuration files here
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
                users.james = {
                  imports = homeManagerModuleConfigs; # Use the filtered HM modules
                };
              };
            }
            # External module inputs
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
