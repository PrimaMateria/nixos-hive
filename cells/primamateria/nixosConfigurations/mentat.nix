{ inputs, cell }:
let
  inherit (cell) bee machines installations system;
in
{
  inherit bee;
  imports = [
    machines.tower
    installations.common
    installations.bare_metal
    {
      imports = [
        # system.docker
        # system.steam
        # rclone
      ];
      networking.hostName = "mentat";
      # TODO: I was trying to pass this shell script through overlay, but it is
      # not picked up
      # primamateria.system.i3.displaySetupScript =
      #   nixpkgs.acerMonitorDisplaySetupScript;
    }
  ];
}
