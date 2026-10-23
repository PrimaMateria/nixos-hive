{
  super,
}: {
  coturn = {
    image = "coturn/coturn:4.18.0";
    container_name = "coturn";
    restart = "unless-stopped";
    # TURN needs a whole relay port range reachable, and publishing 40 udp
    # ports would spawn 40 docker-proxy processes. The host firewall is off,
    # so host networking is both simpler and faster here.
    network_mode = "host";
    volumes = [
      "${super.config}:/etc/coturn/turnserver.conf:ro"
    ];
    # The public address is dynamic DNS, so resolve it at start rather than
    # baking it into the config. coturn only re-reads this on restart, which
    # is the same cadence the address actually changes at.
    entrypoint = "/bin/sh";
    command = [
      "-c"
      # $$ so compose variable substitution leaves a literal $ for the shell.
      "PUB=$$(getent hosts primamateria.ddns.net | awk '{print $$1; exit}'); echo \"coturn external-ip=$$PUB/192.168.2.67\"; exec turnserver -c /etc/coturn/turnserver.conf --external-ip=\"$$PUB/192.168.2.67\""
    ];
    labels = [
      "traefik.enable=false"
    ];
  };
}
