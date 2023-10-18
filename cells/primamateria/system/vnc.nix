{}:
{
  config = {
    services.x2goserver.enable = true;
    services.xserver.autorun = false;
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    environment.systemPackages = with nixpkgs; [
      tigervnc
      xorg.xinit
    ];
  };
}
