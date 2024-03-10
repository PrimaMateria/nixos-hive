{ inputs, cell }:
let
  inherit (inputs) nixpkgs i3blocks-gcalcli;
  inherit (cell) secrets;

  i3block = i3blocks-gcalcli.packages.${nixpkgs.system}.i3blocks-gcalcli;
in
''
  ${i3block}/bin/i3blocks-gcalcli -e "matus.benko@gmail.com" -m "matus.benko@gmail.com" -m "Holidays in Germany" -m "Sviatky na Slovensku" -w 20 --clientId ${secrets.gcalcli.clientId} --clientSecret ${secrets.gcalcli.clientSecret} -f "CaskaydiaCove Nerd Font Mono"
''
