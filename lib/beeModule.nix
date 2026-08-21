# The "bee" module — vendored from divnix/hive (src/beeModule.nix).
#
# It defines the `bee` option set (system / pkgs / home / wsl / darwin) that each
# host configuration declares, and it "erases" the upstream nixpkgs.* options so
# that nixpkgs is configured exclusively through `bee.pkgs`. This is the layer
# that lets a host module stay pkgs-agnostic while we instantiate nixpkgs for it.
{nixpkgs}: {
  config,
  modulesPath,
  ...
}: let
  l = nixpkgs.lib // builtins;

  erase = optionName: instruction: exceptions: {
    options,
    modulesPath,
    ...
  }: let
    opt = l.getAttrFromPath optionName options;
  in {
    options = l.setAttrByPath optionName (l.mkOption {visible = false;});
    config.bee._alerts = [
      {
        assertion =
          !opt.isDefined
          || (
            if exceptions != []
            then l.subtractLists opt.files exceptions == []
            else false
          );
        message = ''
          The option `${l.showOption optionName}' is not supported.
            Location: ${l.showFiles opt.files}
            ${
            if instruction != null
            then instruction
            else ""
          }
        '';
      }
    ];
  };
in {
  imports = [
    (erase ["nixpkgs" "config"] "Please set 'config.bee.pkgs' to a fully configured nixpkgs." [])
    (erase ["nixpkgs" "overlays"] "Please set 'config.bee.pkgs' to a nixpkgs - overlays included." [
      # exceptions in upstream that we can't control
      (modulesPath + "/profiles/installation-device.nix")
    ])
    (erase ["nixpkgs" "system"] "Please set 'config.bee.system', instead." [])
    (erase ["nixpkgs" "localSystem"] "Please set 'config.bee.system', instead." [])
    (erase ["nixpkgs" "crossSystem"] "Please set 'config.bee.system', instead." [])
    (erase ["nixpkgs" "pkgs"] "Please set 'config.bee.pkgs' to an instantiated version of nixpkgs." [])
  ];
  options.bee = {
    _alerts = l.mkOption {
      type = l.types.listOf l.types.unspecified;
      internal = true;
      default = [];
    };
    _evaled = l.mkOption {
      type = l.types.attrs;
      internal = true;
      default = {};
    };
    _unchecked = l.mkOption {
      type = l.types.attrs;
      internal = true;
      default = {};
    };
    system = l.mkOption {
      type = l.types.str;
      description = "requires you to set the host's system via 'config.bee.system = \"x86_64-linux\";'";
    };
    home = l.mkOption {
      type = l.mkOptionType {
        name = "input";
        description = "home-manager input";
        check = x: (l.isAttrs x) && (l.hasAttr "sourceInfo" x);
      };
      description = "requires you to set the home-manager input via 'config.bee.home = inputs.home-manager;'";
    };
    wsl = l.mkOption {
      type = l.mkOptionType {
        name = "input";
        description = "nixos-wsl input";
        check = x: (l.isAttrs x) && (l.hasAttr "sourceInfo" x);
      };
      description = "requires you to set the nixos-wsl input via 'config.bee.wsl = inputs.wsl;'";
    };
    darwin = l.mkOption {
      type = l.mkOptionType {
        name = "input";
        description = "darwin input";
        check = x: (l.isAttrs x) && (l.hasAttr "sourceInfo" x);
      };
      description = "requires you to set the darwin input via 'config.bee.darwin = inputs.darwin;'";
    };
    pkgs = l.mkOption {
      type = l.mkOptionType {
        name = "packages";
        description = "instance of nixpkgs";
        check = x: (l.isAttrs x) && (l.hasAttr "path" x);
      };
      description = "requires you to set the nixpkgs instance via 'config.bee.pkgs = inputs.nixpkgs;'";
      apply = x:
        if (l.hasAttr "${config.bee.system}" x)
        then x.${config.bee.system}
        else x;
    };
  };
}
