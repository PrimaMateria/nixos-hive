{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  xsession = {
    enable = true;
    windowManager.i3 = haumea.load {
      src = ./__i3;
      inputs = { inherit inputs cell; };
      transformer = haumea.lib.transformers.liftDefault;
    };
  };

  services.blueman-applet.enable = true;
}
