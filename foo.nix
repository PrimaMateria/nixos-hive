{ nixpkgs }:
let
  l = nixpkgs.lib // builtins;

  cellBlock = "fooblock";
  target = "footarget";

  self = ({
    x86_64-linux = {
      cell = {
        fooblock = {
          foo = "foo";
        };
        barblock = {
          bar = "bar";
        };
      };
    };
  });

  # ops = (system: cell: [
  #   (l.mapAttrs (target: config: {
  #     _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
  #     imports = [ config ];
  #   }))
  #   (l.mapAttrs (_: checks.bee))
  #   (l.mapAttrs (_: transformers.nixosConfigurations))
  #   (l.filterAttrs (_: config: config.bee.system == system))
  #   (l.mapAttrs (_: config: config.bee._evaled))
  # ]);

  ops = (system: cell: [
    (l.mapAttrs (x: y: {
      bar = "bar";
    }))
  ]);

  # walkPaisano = self: cellBlock: ops: namer:
  #   l.pipe
  # (
  #   l.mapAttrs
  #     (system:
  #       l.mapAttrs (cell: blocks: (
  #         l.pipe blocks (
  #           [ (l.attrByPath [ cellBlock ] { }) ]
  #           ++ (ops system cell)
  #           ++ [ (l.mapAttrs (target: l.nameValuePair (namer cell target))) ]
  #         )
  #       ))
  #     )
  #     (l.intersectAttrs (l.genAttrs l.systems.doubles.all (_: null)) self)
  # )
  # [
  #   (l.collect (x: x ? name && x ? value))
  #   l.listToAttrs
  # ];
in
{
  # nix eval --file foo.nix --arg nixpkgs "import <nixpkgs> {}" product | alejandra --quiet

  product =
    rec {


      # pipes value through list of prcessors
      example_pipe = l.pipe "bar" [ (x: "foo" + x) (x: x + "baz") ];


      # collects only values that match the predicate
      example_collect =
        l.collect (x: x ? name && x ? value)
          {
            foo = { name = "foo"; value = "foo"; };
            bar = { name = "bar"; value = "bar"; };
            baz = { notGood = "notGood"; };
          };

      # creates one set of key-values provided by list containing required
      # name/value sets
      example_listToAttrs = l.listToAttrs [
        { name = "foo"; value = "foo"; }
        { name = "bar"; value = "bar"; }
      ];

      # maps each value of the set 
      example_mapAttrs = l.mapAttrs (key: value: key + value) { foo = "bar"; };

      step1_allSystemsAsList = l.systems.doubles.all;
      step2_allSystemsAsSet = (l.genAttrs step1_allSystemsAsList (_: null));
      step3_selfSystemsSet = (l.intersectAttrs step2_allSystemsAsSet self);
      step4_hoistChosenCellBlocks = (l.mapAttrs
        (system:
          l.mapAttrs (cell: blocks: (
            l.pipe blocks ([
              (l.attrByPath [ cellBlock ] { })
            ] ++ (ops system cell))

          ))
        )
        step3_selfSystemsSet
      );
      # foo =
      #   walkPaisano
      #     self
      #     ({
      #       foo = "foo";
      #     })
      #     (system: cell: system)
      #     (cell: target: cell);
    };
}
