# Book Sync

Syncs the Calibre library between Google Drive and `~/books` using `rclone bisync`. The `~/books` directory is shared by both BookOrbit and Calibre Web.

## Deploy

```bash
hive-reload-home
```

No docker container — just installs rclone and registers a systemd user timer.

## First-time setup on a new machine

### 1. Authenticate with Google Drive

```bash
rclone config
```

- New remote → name it `gdrive`
- Storage type: Google Drive
- Follow the OAuth flow in the browser

### 2. Create the books directory

```bash
mkdir -p /home/primamateria/books
```

### 3. Verify the remote path

```bash
rclone ls gdrive:Calibre-Bibliothek
```

Adjust `Calibre-Bibliothek` in `default.nix` if your Calibre folder has a different name on Drive.

### 4. Initialize bisync state

Run once before the timer takes over:

```bash
rclone bisync gdrive:Calibre-Bibliothek /home/primamateria/books --resync
```

## Manual sync

```bash
systemctl --user start rclone-books-sync
```

The systemd timer runs hourly automatically.
