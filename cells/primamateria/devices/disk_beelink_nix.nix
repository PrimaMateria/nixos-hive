{}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e823b09d-bcbf-4ca3-91bd-01641ad9c762";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B7FB-039E";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];
}
