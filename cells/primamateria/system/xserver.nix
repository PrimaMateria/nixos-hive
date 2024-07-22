{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
in {
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  # display-setup-script for lightdm set in devices/monitor

  services.picom = {
    enable = true;
    backend = "xrender";
    # vSync = true;
    settings = {
      unredir-if-possible = false;
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

  fonts.packages = with nixpkgs; [
    (nerdfonts.override {
      fonts = ["CascadiaCode"];
    })
  ];
}
