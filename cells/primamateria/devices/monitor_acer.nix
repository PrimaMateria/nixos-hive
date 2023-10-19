{ inputs }:
let
  inherit (inputs) nixpkgs;
  acerMonitorDisplaySetupScript = nixpkgs.writeShellApplication {
    name = "displaySetupScript";
    text = ''
      ${nixpkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --rate 143.86 --primary
      ${nixpkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
    '';
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      inherit acerMonitorDisplaySetupscript;
    })
  ];
}
