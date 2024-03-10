{ inputs }:
let
  inherit (inputs) nixpkgs;

  i3block = nixpkgs.writeShellApplication {
    name = "i3block-monitorManager";

    runtimeInputs = [ nixpkgs.hsetroot ];

    text = ''
      status=$(xrandr --query | grep HDMI-0)
      resolutionTest='^.*[0-9]+x[0-9]+\+[0-9]+\+[0-9]+.*$'

      # if click was send
      if [ "''${button:=}" = "1" ]; then

        # if is HDMI turned on
        if [[ $status =~ $resolutionTest ]]; then
          # turn off
          xrandr --output HDMI-0 --off
          hsetroot -solid "#555555"
          # report new status
          echo "Monitor: [1]"
        else
          # turn on
          xrandr --output HDMI-0 --auto --left-of DP-2
          hsetroot -solid "#555555"
          # report new status
          echo "Monitor: [2][1]"
        fi
      else 

        # if is HDMI turned on
        if [[ $status =~ $resolutionTest ]]; then
          # report current status
          echo "Monitor: [2][1]"
        else
          # report current status
          echo "Monitor: [1]"
        fi
      fi
    '';
  };
in
"${i3block}/bin/i3block-monitorManager"

