{
  super,
}: {
  mautrix-discord = {
    image = "dock.mau.dev/mautrix/discord:latest";
    container_name = "mautrix-discord";
    restart = "unless-stopped";
    volumes = [
      "mautrix-discord-data:/data"
      "${super.config}:/seed/config.yaml:ro"
    ];
    entrypoint = "/bin/sh";
    command = [
      "-c"
      "cp /seed/config.yaml /data/config.yaml && chmod 644 /data/config.yaml && exec /usr/bin/mautrix-discord -c /data/config.yaml"
    ];
    networks = ["default"];
    depends_on = ["synapse" "synapse-db"];
  };
}
