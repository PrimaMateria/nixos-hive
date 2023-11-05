{ inputs, cell }:
let
  inherit (cell) bee applications;
in
{
  inherit bee;
  imports = [
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
    applications.shell
    applications.git
  ];
}
