{ inputs, cell, config }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
in
{
  config = {
    services.xserver.desktopManager.xterm.enable = false;
    services.xserver.windowManager.i3.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    # display-setup-script for lightdm set in devices/monitor

    programs.thunar.enable = true;
  };
}
