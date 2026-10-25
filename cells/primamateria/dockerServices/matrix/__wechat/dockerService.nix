{
  cell,
  super,
}: let
  inherit (cell) secrets;
in {
  # Images come from the PrimaMateria/matrix-wechat fork, tag v0.1.0-pm6: the
  # thumbnail fallback for received images, the media-retry backoff, the
  # optional VNC view, and the image-viewer walker, each on its own branch.
  #
  # Runs the vendor WeChat for Linux AppImage (4.1.13, sha256-pinned upstream)
  # under Xvfb and instruments it with Frida. SYS_PTRACE is what frida-inject
  # needs; SYS_CHROOT is for the client's embedded browser sandbox.
  matrix-wechat-runtime = {
    image = "ghcr.io/primamateria/matrix-wechat-runtime@sha256:faac3d5414d8146005c439dfc0d5f6a8b49e9e40be76cd5a72cbf8104d6cf97b";
    container_name = "matrix-wechat-runtime";
    restart = "unless-stopped";
    cap_drop = ["ALL"];
    cap_add = ["SYS_PTRACE" "SYS_CHROOT"];
    security_opt = ["no-new-privileges:true"];
    shm_size = "256m";
    volumes = [
      "matrix-wechat-runtime-data:/home/wechat"
    ];
    # Web UI for QR login and chat inspection. Loopback only; reach it over an
    # ssh tunnel. `login qr` in the management room works without it.
    ports = [
      "127.0.0.1:18742:18742"
      # Opening an image in the client is the only thing that makes WeChat
      # download the original. Tunnel in: ssh -L 5900:127.0.0.1:5900 homeServer
      "127.0.0.1:5900:5900"
    ];
    expose = ["18743"];
    environment = [
      "TZ=UTC"
      "WECHAT_API_TOKEN=${secrets.matrix.wechat.api_token}"
      "WECHAT_WEB_UI=true"
      # Resume the stored session on restart instead of waiting for a
      # phone approval that only `login prompt` can trigger.
      "WECHAT_AUTO_LOGIN=true"
      "WECHAT_VNC=true"
      "WECHAT_VNC_PASSWORD=${secrets.matrix.wechat.vnc_password}"
      # Investigation harness: records attachment writes and accepts hook
      # requests over the private socket. Turn off once the download call is
      # found. See ~/matrix-wechat-deploy/RE-FINDINGS.md.
      "WECHAT_TRACE_MEDIA=true"
    ];
    networks = ["default"];
  };

  matrix-wechat = {
    image = "ghcr.io/primamateria/matrix-wechat@sha256:0502c5143b6f8ce81eeea52e04c4b3e41d9358ac53cab976a4b9e8a1e6d7f781";
    container_name = "matrix-wechat";
    restart = "unless-stopped";
    cap_drop = ["ALL"];
    security_opt = ["no-new-privileges:true"];
    volumes = [
      "matrix-wechat-data:/data"
      "${super.config}:/seed/config.yaml:ro"
      "${super.registration}:/seed/registration.yaml:ro"
    ];
    # The bridge reads both files from /data and refuses to start without the
    # registration, so seed them from the store on every boot rather than
    # letting `-g` mint tokens we cannot see.
    entrypoint = "/bin/sh";
    command = [
      "-c"
      "cp /seed/config.yaml /data/config.yaml && cp /seed/registration.yaml /data/registration.yaml && chmod 600 /data/config.yaml /data/registration.yaml && exec bun /opt/matrix-wechat/packages/matrix-bridge/src/main.ts -c /data/config.yaml"
    ];
    environment = [
      "TZ=UTC"
      "WECHAT_API_TOKEN=${secrets.matrix.wechat.api_token}"
    ];
    networks = ["default"];
    depends_on = {
      synapse.condition = "service_healthy";
      matrix-wechat-runtime.condition = "service_started";
    };
  };
}
