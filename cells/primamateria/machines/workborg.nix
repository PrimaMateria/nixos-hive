# workborg hardware. PLACEHOLDER until install day: replace with the output of
# `nixos-generate-config --root /mnt` (hardware-configuration.nix) on the laptop.
# The filesystems below only let the config build; `build-vm` ignores them.
{
  inputs,
  cell,
}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
