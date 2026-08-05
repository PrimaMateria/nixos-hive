{
  inputs,
  cell,
  config,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  cfg = config.primamateria.system.wireguard;
in
  with lib; {
    options.primamateria.system.wireguard = {
      enable = mkEnableOption "WireGuard VPN server";

      endpoint = mkOption {
        type = types.str;
        description = "Public DNS name clients dial (host:port comes from listenPort).";
      };

      listenPort = mkOption {
        type = types.port;
        default = 51820;
      };

      externalInterface = mkOption {
        type = types.str;
        description = "LAN/WAN-facing interface used for NAT masquerade. Check with `ip route`.";
      };

      subnet = mkOption {
        type = types.str;
        default = "10.100.0.0/24";
        description = "Internal WireGuard subnet. Must not overlap the LAN.";
      };

      serverAddress = mkOption {
        type = types.str;
        default = "10.100.0.1/24";
      };

      clientDns = mkOption {
        type = types.str;
        default = "192.168.2.1";
        description = "DNS server baked into generated client configs.";
      };

      privateKeyFile = mkOption {
        type = types.path;
        description = "Path to the server's WireGuard private key.";
      };

      peers = mkOption {
        default = [];
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {type = types.str;};
            publicKey = mkOption {type = types.str;};
            allowedIPs = mkOption {
              type = types.listOf types.str;
              description = "Tunnel IPs assigned to this peer (usually a single /32).";
            };
            presharedKeyFile = mkOption {
              type = types.nullOr types.path;
              default = null;
            };
          };
        });
      };
    };

    config = mkIf cfg.enable {
      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      networking.firewall.allowedUDPPorts = [cfg.listenPort];

      # NOTE: we deliberately do NOT use `networking.nat` here. On this host the
      # firewall is disabled and Docker owns the iptables nat/FORWARD tables, and
      # the standalone `nat.service` ends up dead (never ordered against wg0's
      # creation), so no masquerade rule is ever installed. Instead we tie the
      # masquerade + forward rules to the wg0 interface lifecycle via
      # postSetup/postShutdown, which run exactly when the interface comes up.

      networking.wireguard.interfaces.wg0 = {
        ips = [cfg.serverAddress];
        listenPort = cfg.listenPort;
        privateKeyFile = toString cfg.privateKeyFile;
        peers =
          map (
            p:
              {
                inherit (p) name publicKey allowedIPs;
              }
              // (optionalAttrs (p.presharedKeyFile != null) {
                presharedKeyFile = toString p.presharedKeyFile;
              })
          )
          cfg.peers;

        # Masquerade tunnel traffic out the WAN interface so replies can route
        # back, and explicitly allow wg0<->WAN forwarding (belt-and-suspenders in
        # case Docker ever flips the FORWARD policy to DROP).
        postSetup = ''
          ${nixpkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.subnet} -o ${cfg.externalInterface} -j MASQUERADE
          ${nixpkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o ${cfg.externalInterface} -j ACCEPT
          ${nixpkgs.iptables}/bin/iptables -A FORWARD -i ${cfg.externalInterface} -o wg0 -j ACCEPT
        '';
        postShutdown = ''
          ${nixpkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg.subnet} -o ${cfg.externalInterface} -j MASQUERADE
          ${nixpkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o ${cfg.externalInterface} -j ACCEPT
          ${nixpkgs.iptables}/bin/iptables -D FORWARD -i ${cfg.externalInterface} -o wg0 -j ACCEPT
        '';
      };

      environment.systemPackages = [
        (nixpkgs.writeShellApplication {
          name = "wg-newpeer";
          runtimeInputs = with nixpkgs; [wireguard-tools qrencode];
          text = ''
            if [ $# -ne 2 ]; then
              echo "usage: wg-newpeer <name> <tunnel-ip>" >&2
              echo "  example: wg-newpeer phone 10.100.0.2" >&2
              exit 1
            fi
            NAME=$1
            IP=$2
            SERVER_PUB=$(wg pubkey < ${toString cfg.privateKeyFile})
            ENDPOINT="${cfg.endpoint}:${toString cfg.listenPort}"

            umask 077
            CLIENT_KEY=$(wg genkey)
            CLIENT_PUB=$(echo "$CLIENT_KEY" | wg pubkey)
            PSK=$(wg genpsk)

            CONFIG="[Interface]
            PrivateKey = $CLIENT_KEY
            Address = $IP/32
            DNS = ${cfg.clientDns}

            [Peer]
            PublicKey = $SERVER_PUB
            PresharedKey = $PSK
            Endpoint = $ENDPOINT
            AllowedIPs = 0.0.0.0/0, ::/0
            PersistentKeepalive = 25"

            echo "=== public key — paste into secrets/default.nix as wireguard.peers.$NAME.publicKey ==="
            echo "$CLIENT_PUB"
            echo
            echo "=== preshared key — save to secrets/wireguard/$NAME.psk ==="
            echo "$PSK"
            echo
            echo "=== client config — save to secrets/wireguard/clients/$NAME.conf ==="
            echo "$CONFIG"
            echo
            echo "=== QR — scan with WireGuard mobile app ==="
            echo "$CONFIG" | qrencode -t ansiutf8
          '';
        })
      ];
    };
  }
