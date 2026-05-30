# BookOrbit

Self-hosted digital library and reading platform. Accessible at `https://books.primamateria.ddns.net`.

Books are served from `~/books` — see `../booksync/README.md` for how that directory is populated from Google Drive.

## Deploy

```bash
hive-reload-home && run-bookorbit
```

## First login

Open `https://books.primamateria.ddns.net`. Use the bootstrap token from `secrets/default.nix` (`bookorbit.setupBootstrapToken`) to create the admin account.
