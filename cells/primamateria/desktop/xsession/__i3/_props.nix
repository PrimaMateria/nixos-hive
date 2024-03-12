{ inputs, cell, root, self }:
let
  inherit (inputs) nixpkgs;
  inherit (root) i3blocks menus;
in
{
  mod = "Mod1"; # alt

  palette = {
    colorDominant = "#FFFFFF";
    colorProminent = "#FABD2F";
    colorDrab = "#464646";
    colorBackground = "#000000";
    colorBackgroundBar = "#000000";
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
    inherit (menus) commands scratchpad;
    favorites = "${menus.favorites} ${self.favorites}";
  };

  statusBars = {
    main = "${nixpkgs.i3blocks}/bin/i3blocks -c ${i3blocks}";
  };

  modes = {
    system = "System (e) logout, (s) suspend, (r) reboot, (Shift+s) shutdown";
    resize = "Resize";
  };

  favorites = nixpkgs.writeText "favorites" ''
    terminal: alacritty
    browser: firefox
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
