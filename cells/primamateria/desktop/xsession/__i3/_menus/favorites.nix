{
  inputs,
  super,
}: let
  inherit (inputs) nixpkgs;

  favorites = nixpkgs.writeShellApplication {
    name = "dmenu-favorites";
    text = ''
      # Sligthly modified dmenu to provide also descriptions
      # Input argument is a file in following format:
      #    Description: Command
      #    Description: Command
      file=$1

      # Execute dmenu
      selection=$(${super.dmenu.dmenu} < "$file" | awk -F ':' '{print $2}' )

      # Trim
      selection=$(echo "$selection" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

      # Execute selected program
      if [ -n "$selection" ]; then
        nohup "$selection" &
      fi
    '';
  };
in "${favorites}/bin/dmenu-favorites"
