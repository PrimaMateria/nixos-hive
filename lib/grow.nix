# Minimal cell grower + configuration collectors.
#
# Replaces divnix/hive's `growOn` + `collect` for the two block types this repo
# actually uses (nixosConfigurations, homeConfigurations). Everything else hive
# provided (std/paisano CLI actions, devshells, the TUI) is intentionally dropped.
#
# Cell model, per system:
#   - `cells/<cell>/bees.nix`            -> plain functions block (attrset of bees)
#   - `cells/<cell>/<block>/default.nix` -> plain functions block (e.g. secrets)
#   - `cells/<cell>/<block>/`            -> findLoad block (siblings become attrs)
# Each cell file keeps the `{inputs, cell}` signature. `inputs.nixpkgs` is the
# instantiated (allowUnfree) package set for that system, mirroring std's grow.
{
  lib,
  nixpkgs, # the nixpkgs flake (for .lib and its source path)
  haumea,
  inputs, # all raw flake inputs
  cellsFrom, # e.g. ./cells
  systems ? ["x86_64-linux" "aarch64-linux"],
  nixpkgsConfig ? {allowUnfree = true;},
}: let
  l = lib // builtins;
  inherit (builtins) readDir;

  loader = import ./loader.nix {inherit lib haumea;};
  inherit (loader) findLoad;

  beeModule = import ./beeModule.nix {inherit nixpkgs;};

  # nixpkgs instantiated per system, exactly like `nixpkgsConfig` in growOn.
  pkgsFor = system:
    import nixpkgs {
      inherit system;
      config = nixpkgsConfig;
    };

  # Inputs as seen from inside cells: `nixpkgs` becomes an instantiated pkgs set,
  # all other inputs stay as their flakes.
  cellInputsFor = system: inputs // {nixpkgs = pkgsFor system;};

  # Load one block of a cell into its attrset value.
  loadBlock = {
    cellPath,
    cellArgs,
    name,
    type,
  }: let
    path = cellPath + "/${name}";
  in
    if type == "regular"
    # a bare `<block>.nix` file, e.g. bees.nix -> plain functions block
    then (import path) cellArgs
    else if l.pathExists (path + "/default.nix")
    # a directory carrying its own default.nix, e.g. secrets -> plain functions block
    then (import (path + "/default.nix")) cellArgs
    # a plain directory -> findLoad the siblings
    else
      findLoad {
        inherit (cellArgs) inputs cell;
        block = path;
      };

  blockName = name: l.removeSuffix ".nix" name;

  # Build the fixpoint `cell` attrset for one cell under one system.
  growCell = system: cellPath: let
    cellArgs = {
      inputs = cellInputsFor system;
      inherit cell;
    };
    entries = readDir cellPath;
    cell =
      l.mapAttrs' (name: type:
        l.nameValuePair (blockName name)
        (loadBlock {inherit cellPath cellArgs name type;}))
      entries;
  in
    cell;

  cellNames = l.attrNames (l.filterAttrs (_: t: t == "directory") (readDir cellsFrom));

  # cells."<system>"."<cell>" = grown cell
  cellsBySystem =
    l.genAttrs systems (system:
      l.genAttrs cellNames (cellName:
        growCell system (cellsFrom + "/${cellName}")));

  renamer = cell: target: "${cell}-${target}";

  # -- bee extraction (mirrors hive's checks.bee) ------------------------------
  mkChecked = {
    cellName,
    blockType,
    target,
    module,
  }: let
    locatedConfig = {
      _file = "Cell: ${cellName} - Block: ${blockType} - Target: ${target}";
      imports = [module];
    };
    evaled = l.evalModules {
      modules = [
        locatedConfig
        beeModule
        {
          config._module.check = true;
          config._module.freeformType = l.types.unspecified;
        }
      ];
      specialArgs = {
        modulesPath = builtins.toString "${nixpkgs}/nixos/modules";
      };
    };
  in {inherit locatedConfig evaled;};

  # -- nixosConfigurations transformer (mirrors hive) --------------------------
  buildNixos = {
    locatedConfig,
    evaled,
  }: let
    bee = evaled.config.bee;
    extraConfig = {
      nixpkgs = {inherit (bee) system pkgs;};
      imports =
        l.optionals evaled.options.bee.home.isDefined [
          bee.home.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ]
        ++ l.optionals evaled.options.bee.wsl.isDefined [
          bee.wsl.nixosModules.wsl
          {wsl.enable = l.mkDefault true;}
        ];
    };
  in
    import (bee.pkgs.path + "/nixos/lib/eval-config.nix") {
      system = null;
      modules = [beeModule locatedConfig extraConfig {config._module.check = true;}];
    };

  # -- homeConfigurations transformer (mirrors hive) ---------------------------
  buildHome = {
    locatedConfig,
    evaled,
  }: let
    bee = evaled.config.bee;
    hmLib = import (bee.home + /modules/lib/stdlib-extended.nix) l;
    hmModules = import (bee.home + /modules/modules.nix) {
      inherit (bee) pkgs;
      lib = hmLib;
      check = true;
      useNixpkgsModule = false;
    };
    evaledHome = hmLib.evalModules {
      specialArgs = {
        modulesPath = l.toString (bee.home + /modules);
      };
      modules = [beeModule locatedConfig {config._module.check = true;}] ++ hmModules;
    };
  in {
    inherit (evaledHome) options config;
    inherit (evaledHome.config.home) activationPackage;
    newsDisplay = evaledHome.config.news.display;
    newsEntries =
      l.sort (a: b: a.time > b.time)
      (l.filter (a: a.condition) evaledHome.config.news.entries);
  };

  # Collect one block type across all cells/systems, keeping only targets whose
  # `bee.system` matches the system they were grown under.
  collect = {
    blockType,
    build,
  }:
    l.listToAttrs (l.concatMap (
        system:
          l.concatLists (l.mapAttrsToList (
              cellName: cell: let
                block = cell.${blockType} or {};
              in
                l.filter (x: x != null) (l.mapAttrsToList (
                    target: module: let
                      checked = mkChecked {inherit cellName blockType target module;};
                    in
                      if checked.evaled.config.bee.system == system
                      then l.nameValuePair (renamer cellName target) (build checked)
                      else null
                  )
                  block)
            )
            cellsBySystem.${system})
      )
      systems);
in {
  nixosConfigurations = collect {
    blockType = "nixosConfigurations";
    build = buildNixos;
  };
  homeConfigurations = collect {
    blockType = "homeConfigurations";
    build = buildHome;
  };
}
