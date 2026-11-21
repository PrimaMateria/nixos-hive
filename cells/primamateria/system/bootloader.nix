{}: {
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
    # The ESP is 511M and a kernel+initrd pair is roughly 20M, so an uncapped
    # entry list fills it and nixos-rebuild then dies with ENOSPC. Keep enough
    # to roll back, not enough to run out.
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
  };
}
