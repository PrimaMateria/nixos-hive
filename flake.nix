# flake.nix
{
  description = "PrimaMateria's NixOS configuration";

  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";

    nixpkgs.follows = "nixpkgs-stable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        arion.follows = "arion";
        devshell.follows = "devshell";
        devshell.inputs.nixpkgs.follows = "nixpkgs";
        nixago.follows = "nixago";
      };
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        disko.follows = "disko";
        colmena.follows = "colmena";
        nixos-generators.follows = "nixos-generators";
      };
    };

    colmena = {
      url = "https://flakehub.com/f/zhaofengli/colmena/0.4.0.tar.gz";
      inputs.flake-compat.follows = "";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators/1.7.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url =
        "github:nix-community/disko/5d9f362aecd7a4c2e8a3bf2afddb49051988cab9";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, hive, std, ... }@inputs:
    let
      collect = hive.collect // { renamer = cell: target: "${target}"; };
      # lib = inputs.nixpkgs.lib // buitlins;
      lib = inputs.nixpkgs.lib;
    in
    hive.growOn
      {
        inherit inputs;

        cellsFrom = ./cells;
        cellBlocks = with std.blockTypes; [
          # modules
          (functions "devices")
          (functions "system")
          (functions "machines")
          (functions "installations")
          (functions "applications")

          # suites
          (functions "nixosSuites")
          (functions "homeSuites")

          # configurations
          # nixosConfigurations
          # diskoConfigurations
          # colmenaConfigurations
          # (installables "generators")
          # (installables "installers")


          # pkgs
          # (pkgs "pkgs")

          # devshells
          # (nixago "configs")
          # (devshells "devshells")
        ];

        nixpkgsConfig.allowUnfreePredicate = pkg:
          lib.elem (lib.getName pkg) [
            "discord"
          ];
      }
      {
        # devShells = std.harvest self [ "repo" "devshells" ];
        # packages =
        #   let
        #     # generators = std.harvest self [ "repo" "generators" ];
        #     # installers = std.harvest self [ "primamateria" "installers" ];
        #   in
        #   {
        #     inherit (installers) x86_64-linux;
        #   };
      }
      # maybe not needed, might get rid of it later
      {
        # nixosConfigurations = collect self "nixosConfigurations";
        # colmenaHive = collect self "colmenaConfigurations";
        # nixosModules = collect self "nixosModules";
        # hmModules = collect self "homeModules";
      };
}
