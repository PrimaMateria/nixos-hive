{}:
{
  config = {
    services.xserver.desktopManager.xterm.enable = false;
    services.xserver.windowManager.i3.enable = true;
    services.xserver.displayManager.lightdm = {
      enable = true;
      # TODO: display setup script
      extraSeatDefaults = ''
        # display-setup-script = ${displaySetupScript}/bin/displaySetupScript
      '';
    };

    programs.thunar.enable = true;
  };
}
