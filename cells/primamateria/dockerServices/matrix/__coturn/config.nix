{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "turnserver.conf";
    text = ''
      # Synapse hands clients ephemeral HMAC credentials derived from this
      # secret, so there are no static TURN users.
      use-auth-secret
      static-auth-secret=${secrets.matrix.coturn.static_auth_secret}
      realm=matrix.primamateria.ddns.net

      # Host networking, so bind explicitly to the LAN interface instead of
      # every docker bridge and wg0. external-ip is appended by the entrypoint
      # because the public address comes from dynamic DNS.
      listening-ip=192.168.2.67
      relay-ip=192.168.2.67
      listening-port=3478
      min-port=49160
      max-port=49200

      # No TLS listener: the only certificate in secrets expired in 2025 and
      # has no matrix.* SAN. WebRTC media is SRTP-encrypted regardless.
      # DTLS and the CLI are both off by default in 4.18; the explicit
      # no-dtls / no-cli options were removed and now just warn.
      no-tls

      fingerprint
      no-multicast-peers
      no-tcp-relay

      # Never let the relay be used to reach the LAN, the docker bridges or
      # the wireguard subnet.
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      denied-peer-ip=::1
      denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
      denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
      denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
      denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff

      user-quota=12
      total-quota=1200
    '';
  }
