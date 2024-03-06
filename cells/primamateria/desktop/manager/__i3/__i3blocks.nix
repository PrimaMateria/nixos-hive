{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell.secrets.gcalcli) clientId clientSecret;
in
nixpkgs.writeText "i3blocks-config" ''
  separator_block_width=20
  markup=none

  [monitor]
  command=${nixpkgs.i3block-monitorManager}/bin/i3block-monitorManager
  interval=5000

  [kbdd_layout]
  command=${nixpkgs.i3blocks-contrib.kbdd_layout}/libexec/i3blocks/kbdd_layout
  interval=persist

  [volume-pulseaudio]
  command=${nixpkgs.i3blocks-contrib.volume-pulseaudio}/libexec/i3blocks/volume-pulseaudio -H "" -M "" -L "" -X ""
  interval=once
  signal=1
  LONG_FORMAT="''${VOL}% [''${NAME}]"
  SHORT_FORMAT="''${VOL}% [''${INDEX}]"
  DEFAULT_COLOR=#FBF1C7
    
  [gcalcli]
  command=${nixpkgs.i3blocks-gcalcli}/bin/i3blocks-gcalcli -e "matus.benko@gmail.com" -m "matus.benko@gmail.com" -m "Holidays in Germany" -m "Sviatky na Slovensku" -w 20 --clientId ${clientId} --clientSecret ${clientSecret} -f "CaskaydiaCove Nerd Font Mono"
  interval=1800

  [datetime]
  command="${nixpkgs.i3block-datetime}/bin/i3block-datetime"
  interval=1
''
