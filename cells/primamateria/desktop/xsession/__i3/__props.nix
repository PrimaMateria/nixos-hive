{ inputs, root }:
let
  inherit (inputs) nixpkgs;
  inherit (root) i3blocks;
in
{
  mod = "Mod1"; # alt

  palette = {
    colorDominant = "#FBF1C7";
    colorProminent = "#FABD2F";
    colorDrab = "#464646";
    colorBackground = "#000000";
    colorBackgroundBar = "#303030";
    colorAlert = "#FF0000";
  };

  workspace = n: builtins.elemAt [
    "10: Messier 87"
    "1: Sun"
    "2: Mercury"
    "3: Venus"
    "4: Earth"
    "5: Mars"
    "6: Jupiter"
    "7: Saturn"
    "8: Chat"
    "9: Music"
  ]
    n;

  menus = {
    commands = "${nixpkgs.dmenu}/bin/dmenu_run -nb black -nf white -sb yellow -sf black -l 20 -c";
    # TODO:
    # favorites = "${nixpkgs.dmenu-run-from-file}/bin/dmenu ${favorites}";
    # scratchpad = "${nixpkgs.dmenu-i3-scratchpad}/bin/dmenu";
    favorites = "${nixpkgs.dmenu}/bin/dmenu_run -nb black -nf white -sb yellow -sf black -l 20 -c";
    scratchpad = "${nixpkgs.dmenu}/bin/dmenu_run -nb black -nf white -sb yellow -sf black -l 20 -c";
  };

  statusBars = {
    main = "${nixpkgs.i3blocks}/bin/i3blocks -c ${i3blocks}";
  };

  modes = {
    system = "System (e) logout, (s) suspend, (r) reboot, (Shift+s) shutdown";
    resize = "Resize";
  };

  favorites = nixpkgs.writeText "favorites" ''
    ebooks: calibre
    files: doublecmd
    image Editor: gimp
    image Viewer: qimgv
    led: openrgb
    mouse: piper
    office: libreoffice
    pdf: sioyek
    scanner: simple-scan
    screenshot: flameshot
    speakers control: pavucontrol
    stream: obs-studio
  '';
}
