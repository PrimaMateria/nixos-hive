{
  super,
}: {
  mautrix-whatsapp = {
    image = "dock.mau.dev/mautrix/whatsapp:latest";
    container_name = "mautrix-whatsapp";
    restart = "unless-stopped";
    volumes = [
      "mautrix-whatsapp-data:/data"
      "${super.config}:/seed/config.yaml:ro"
    ];
    entrypoint = "/bin/sh";
    command = [
      "-c"
      "cp /seed/config.yaml /data/config.yaml && chmod 644 /data/config.yaml && exec /usr/bin/mautrix-whatsapp -c /data/config.yaml"
    ];
    networks = ["default"];
    depends_on = ["synapse" "synapse-db"];
  };
}
