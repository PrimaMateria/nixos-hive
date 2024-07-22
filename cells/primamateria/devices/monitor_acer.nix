# This is not a nix module, just a custom set that provides one package.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  displaySetup = nixpkgs.writeShellApplication {
    name = "setup";
    text = ''
      ${nixpkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --rate 143.86 --primary
      ${nixpkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
    '';
  };
in {
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    display-setup-script = ${displaySetup}/bin/setup
  '';
}
