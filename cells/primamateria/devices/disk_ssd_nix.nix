{}: {
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/c2a243c4-a7c7-4ef2-aea7-f4ef53707114";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/7E6C-5F96";
      fsType = "vfat";
    };

    swapDevices = [];
  };
}
