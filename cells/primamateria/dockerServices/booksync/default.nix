{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = [nixpkgs.rclone];

  systemd.user.services.rclone-books-sync = {
    Unit = {
      Description = "Sync Calibre library from Google Drive to books directory";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${nixpkgs.rclone}/bin/rclone bisync gdrive:Calibre-Bibliothek /home/primamateria/books --create-empty-src-dirs --resilient";
    };
  };

  systemd.user.timers.rclone-books-sync = {
    Unit = {
      Description = "Hourly timer for Calibre library sync from Google Drive";
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
