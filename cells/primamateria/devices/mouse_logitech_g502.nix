{
  inputs,
  cell,
}: {
  config = {
    # Pointer speed is set in niri (homeConfigurations/mentat.nix).
    services.ratbagd.enable = true;
  };
}
