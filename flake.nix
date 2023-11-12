#             ██            
#       ██  ██████  ██      
#     ██      ██      ██    
#   ██  ██    ██    ██  ██  
#         ██  ██  ██        
#   ██      ██████      ██  
# ██████████████████████████
#   ██      ██████      ██  
#         ██  ██  ██        
#   ██  ██    ██    ██  ██  
#     ██      ██      ██    
#       ██  ██████  ██      
#             ██            

{
  description = "PrimaMateria's NixOS configuration";

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
          (functions "secrets")
          nixosConfigurations
          homeConfigurations
        ];
      }
      {
        # sudo nixos-rebuild switch --flake .#primamateria-gg  
        # sudo nixos-rebuild dry-activate --flake .#primamateria-gg  
        nixosConfigurations = hive.collect self "nixosConfigurations";

        # nix build .#homeConfigurations.primamateria-gg.activationPackage
        # ./result/activate
        homeConfigurations = hive.collect self "homeConfigurations";
      };

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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hive = {
      url = "github:divnix/hive";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
