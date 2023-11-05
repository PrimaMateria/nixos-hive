{ inputs, cell }:
{
  config = {
    fileSystems."/mnt/c" =
      {
        device = "/dev/disk/by-uuid/6C8A776F8A773524";
        fsType = "ntfs";
        options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
      };
  };
}
