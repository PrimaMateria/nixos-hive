{ inputs, config }:
let
  inherit (inputs) nixpkgs;
  cfg = config.primamateria.system.i3;
in
{
  options = {
    displaySetupScript = nixkpgs.mkPackageOption displaySetupScript {
      nullable = true;
      default = true;
    };
  };
  config = {
    services.xserver.desktopManager.xterm.enable = false;
    services.xserver.windowManager.i3.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.displayManager.lightdm.extraSeatDefaults = mkIf
      (!(cfg.displaySetupScript == null)) ''
      display-setup-script = ${displaySetupScript}/bin/displaySetupScript
    '';
  };

  programs.thunar.enable = true;
}
