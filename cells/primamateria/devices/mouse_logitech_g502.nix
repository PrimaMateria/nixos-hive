{ inputs, cell }:
{
  config = {
    services.xserver.inputClassSections = [
      ''
        Identifier      "Logitech G502 HERO Gaming Mouse sensitivity"
        MatchProduct    "Logitech G502 HERO Gaming Mouse"
        MatchIsPointer  "true"
        Option          "ConstantDeceleration" "3"
        Driver          "evdev"
      ''
    ];
    services.ratbagd.enable = true;
  };
}
