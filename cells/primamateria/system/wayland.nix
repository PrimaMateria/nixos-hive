# Wayland desktop, system side: niri compositor, Noctalia shell, greetd login,
# fonts. The per-user config (niri binds, Noctalia settings, foot) lives in
# desktop/wayland.nix.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  programs.niri.enable = true;

  # Noctalia's systemd user service comes from home-manager; here only the
  # package and the services its widgets talk to (NetworkManager, bluetooth,
  # UPower, power profiles).
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${nixpkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  };

  fonts.packages = with nixpkgs; [
    # Bitmap font for foot (includes Nerd Font icons).
    cozette
    # Icon fallback for anything Cozette lacks.
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with nixpkgs; [
    xwayland-satellite # X11 apps under niri
    brightnessctl
    playerctl
    wl-clipboard
  ];
}
