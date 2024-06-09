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

  outputs = {
    self,
    hive,
    std,
    ...
  } @ inputs:
    hive.growOn
    {
      inherit inputs;

      nixpkgsConfig.allowUnfree = true;

      cellsFrom = ./cells;
      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        (functions "bees")
        (functions "devices")
        (functions "system")
        (functions "machines")
        (functions "installations")
        (functions "cli")
        (functions "environments")
        (functions "desktop")
        (functions "secrets")
        (functions "raspberrypi")
        nixosConfigurations
        homeConfigurations
      ];
    }
    {
      # sudo nixos-rebuild switch --flake .#primamateria-gg
      # sudo nixos-rebuild dry-activate --flake .#primamateria-mentat --show-trace --option eval-cache false
      nixosConfigurations = hive.collect self "nixosConfigurations";

      # nix build .#homeConfigurations.primamateria-gg.activationPackage
      # ./result/activate
      homeConfigurations = hive.collect self "homeConfigurations";
    };

  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes"];
    allowUnfree = true;
  };

  # Hive inputs
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    nixpkgs.follows = "nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # My inputs
  inputs = {
    dmenu-primamateria = {
      url = "github:PrimaMateria/dmenu";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    i3blocks-gcalcli = {
      url = "github:PrimaMateria/i3blocks-gcalcli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    i3blocks-contrib = {
      url = "github:vivien/i3blocks-contrib";
      flake = false;
    };
  };
}
