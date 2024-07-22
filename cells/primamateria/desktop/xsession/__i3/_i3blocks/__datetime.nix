{inputs}: let
  inherit (inputs) nixpkgs;

  i3block = nixpkgs.writeShellApplication {
    name = "i3block-datetime";
    text = ''
      DATETIME=$(date +'%H:%M %A %d.%m.%Y')
      echo "$DATETIME"
      echo "$DATETIME"
      echo "#FABD2F"
      exit 0
    '';
  };
in "${i3block}/bin/i3block-datetime"
