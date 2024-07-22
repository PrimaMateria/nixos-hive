# Raspberry Pi 5 was running Raspbian with Pure Nix. Some configurations that I
# couldn't write in Nix, I attempted to write as a bash configuration script. In
# addition to other installations, the configuration script also installed
# Docker and Docker Compose, which were used to run Traefik and services. The
# Raspberry Pi 5 was later replaced with a Beelink running full NixOS. Meanwhile
# this config was refactored but not evaluated so I am not sure if it is in
# working state.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (cell) bees cli dockerServices;
in {
  bee = bees.rpi;
  imports = [
    cli.pureNix
    cli.hive
    cli.shellMin
    cli.rpi5Configurer
    dockerServices.traefik
    dockerServices.freshrss
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
