# Directory-to-modules loader — vendored from divnix/hive's flake `load`/`findLoad`.
#
# `load`    turns a single source path (a .nix file, or a directory loaded via
#           haumea with the default/liftDefault + _imports->imports transformers)
#           into a NixOS/home-manager module, auto-passing the declared arguments
#           (`inputs`, `cell`, and any module args) into the underlying function.
# `findLoad` enumerates a block directory (every entry except default.nix) and
#           loads each into an attribute, reproducing hive's per-block index.
#
# This replaces `inputs.hive.findLoad` so the cell files keep their exact
# `{inputs, cell}` calling convention with byte-identical loading behaviour.
{
  lib,
  haumea,
}: let
  inherit (builtins) readDir removeAttrs baseNameOf;
  inherit (lib) functionArgs pipe toFunction;

  # `label` only feeds module-location error messages; it has no effect on
  # evaluated values (in hive it was "${self.outPath}#<cell-route>").
  load = {
    inputs,
    cell,
    src,
    label ? "nixos-hive",
  }:
  # modules/profiles are always functions
  args @ {
    config,
    pkgs,
    ...
  }: let
    file = "${label}#${baseNameOf src}";

    defaultWith = importer: inputs: path: let
      f = toFunction (importer path);
    in
      pipe f [
        functionArgs
        (builtins.mapAttrs (
          name: _:
            builtins.addErrorContext
            "while evaluating the argument `${name}' in \"${file}\":"
            (inputs.${name} or config._module.args.${name})
        ))
        f
      ];
    loader = inputs: defaultWith (scopedImport inputs) inputs;
    i = args // {inherit cell inputs;};
  in
    if lib.pathIsDirectory src
    then
      lib.setDefaultModuleLocation file (haumea.lib.load {
        inherit loader src;
        transformer = with haumea.lib.transformers; [
          liftDefault
          (hoistLists "_imports" "imports")
        ];
        inputs = i;
      })
    # Mimic haumea for a regular file
    else lib.setDefaultModuleLocation file (loader i src);

  findLoad = {
    inputs,
    cell,
    block,
    label ? "nixos-hive",
  }:
    lib.mapAttrs'
    (n: _:
      lib.nameValuePair
      (lib.removeSuffix ".nix" n)
      (load {
        inherit inputs cell label;
        src = block + "/${n}";
      }))
    (removeAttrs (readDir block) ["default.nix"]);
in {
  inherit load findLoad;
}
