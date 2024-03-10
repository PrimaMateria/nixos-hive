{ super, inputs, cell }:
let
  inherit (inputs) nixpkgs;
in

nixpkgs.writeText "i3blocks-config" ''
  separator_block_width=20
  markup=none

  [monitor]
  command=${super.monitorManager}
  interval=5000

  [kbdd_layout]
  command=${super.kbdd_layout}
  interval=persist

  [volume-pulseaudio]
  command=${super.volume-pulseaudio}
  interval=once
  signal=1
  LONG_FORMAT="''${VOL}% [''${NAME}]"
  SHORT_FORMAT="''${VOL}% [''${INDEX}]"
  DEFAULT_COLOR=#FBF1C7

  [datetime]
  command=${super.datetime}
  interval=1

  [gcalcli]
  command=${super.gcalcli}
  interval=1800
''



