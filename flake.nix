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
    nixpkgs,
    haumea,
    ...
  } @ inputs: let
    grown = import ./lib/grow.nix {
      inherit (nixpkgs) lib;
      inherit nixpkgs haumea inputs;
      cellsFrom = ./cells;
      systems = ["x86_64-linux" "aarch64-linux"];
      nixpkgsConfig = {allowUnfree = true;};
    };
  in {
    # sudo nixos-rebuild switch --flake .#primamateria-gg
    # sudo nixos-rebuild dry-activate --flake .#primamateria-mentat --show-trace --option eval-cache false
    inherit (grown) nixosConfigurations;

    # nix build .#homeConfigurations.primamateria-gg.activationPackage
    # ./result/activate
    inherit (grown) homeConfigurations;
  };

  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes"];
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
    allowUnfree = true;
  };

  # Framework inputs
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

    llm-agents.url = "github:numtide/llm-agents.nix";

    bitbucket-cli.url = "github:avivsinai/bitbucket-cli";

    zhongwen = {
      url = "github:PrimaMateria/zhongwen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No-build static HTML game; served as-is from its source tree.
    kpop-game = {
      url = "github:PrimaMateria/kpop-game";
      flake = false;
    };
  };
}
