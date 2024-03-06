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

    services.picom = {
      enable = true;
      backend = "xrender";
      # vSync = true;
      shadow = true;
      shadowExclude = [
        "window_type *= 'menu'"
        "class_g = 'i3bar'"
      ];
      settings = {
        unredir-if-possible = false;
        shadow-color = "#FFFFFF";
        shadow-radius = 30;
        shadow-offset-x = -30;
        shadow-offset-y = -30;
        shadow-opacity = 0.3;
        shadow-ignore-shaped = true;
      };
    };

    programs.thunar.enable = true;

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/file" = "thunar.desktop";
        "inode/directory" = "thunar.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/discord-402572971681644545" = "discord-402572971681644545.desktop";
      };
    };
  };
}
