# Wetty

Web terminal accessible at `https://term.primamateria.ddns.net`. Connects via SSH to the host and drops into tmux automatically.

## Deploy

```bash
hive-reload-home && run-traefik && run-wetty
```

## Login

Enter the Linux user password for `primamateria` when prompted. Drops directly into the most recent tmux session, or creates a new one if none exist.
