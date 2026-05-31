# Calibre Web

Web interface for the Calibre library with Kindle email sending. Accessible at `https://calibre.primamateria.ddns.net`.

Shares the `~/books` directory with BookOrbit. Books can be added here and will sync back to Google Drive via rclone bisync (see BookOrbit README).

## Deploy

```bash
hive-reload-home && run-calibreweb
```

## First login

Default credentials: `admin` / `admin123`. Change the password immediately after login.

Set the library path to `/books` when prompted on first run.

## Enable uploads

Admin → Basic Configuration → Feature Configuration → Enable Uploads.

## Kindle email setup

Admin → Basic Configuration → Email Server:

- SMTP host: `smtp.eu.mailgun.org`
- Port: `587`
- Username: `postmaster@primamateria.ddns.net`
- Password: from `secrets/default.nix` (`mailgun.smtpPassword`)
- From: `books@primamateria.ddns.net`

Then set your Kindle address in Admin → Edit User → Send to Kindle E-Mail.

### Approve sender on Amazon

Add `books@primamateria.ddns.net` to the approved senders list at:
`amazon.com → Account → Manage Your Content and Devices → Preferences → Personal Document Settings`
