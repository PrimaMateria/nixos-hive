{ inputs, cell }:
let
  inherit (cell) bee applications;
in
{
  inherit bee;
  # inherit pkgs;
  # extraSpecialArgs = {
  #   inherit watson-jira-next pkgs-unstable;
  # };
  modules = [
    {
      home = {
        username = "mbenko";
        homeDirectory = "/home/mbenko";
        stateVersion = "22.05";
      };
    }
    applications.shell
  ];
}
