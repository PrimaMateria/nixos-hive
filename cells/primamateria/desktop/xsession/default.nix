{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs haumea;
in {
  xsession = {
    enable = true;
    windowManager.i3 = haumea.lib.load {
      src = ./__i3;
      inputs = {inherit inputs cell;};
      transformer = haumea.lib.transformers.liftDefault;
    };
  };

  services.blueman-applet.enable = true;
}
