{
  super,
}: {
  heisenbridge = {
    image = "hif1/heisenbridge:latest";
    container_name = "heisenbridge";
    restart = "unless-stopped";
    volumes = [
      "heisenbridge-data:/data"
      "${super.registration}:/seed/registration.yaml:ro"
    ];
    entrypoint = "/bin/sh";
    command = [
      "-c"
      "[ -f /data/registration.yaml ] || (cp /seed/registration.yaml /data/registration.yaml && chmod 644 /data/registration.yaml) && exec python -m heisenbridge -c /data/registration.yaml -o '@primamateria:matrix.primamateria.ddns.net' http://synapse:8008"
    ];
    depends_on = ["synapse"];
  };
}
