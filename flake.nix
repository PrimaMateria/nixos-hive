{
  description = "PrimaMateria's NixOS configuration";

  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    allowUnfree = true;
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";

    nixpkgs.follows = "nixpkgs-stable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, hive, std, ... }@inputs:
    hive.growOn
      {
        inherit inputs;

        cellsFrom = ./cells;
        cellBlocks = with std.blockTypes; with hive.blockTypes; [
          (functions "bee")
          (functions "devices")
          (functions "system")
          (functions "machines")
          (functions "installations")
          (functions "applications")
          nixosConfigurations
        ];
      }
      {
        nixosConfigurations = hive.collect self "nixosConfigurations";
      };
}
