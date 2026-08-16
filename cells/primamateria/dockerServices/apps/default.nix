{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  domain = "apps.primamateria.ddns.net";

  # Static projects to serve. Each project file returns
  # { name; title; description; root; } where `root` is a folder (store path)
  # containing the built site. Served at https://${domain}/<name>/.
  # To add a project: create ./_projects/<name>.nix and add it to this list.
  # (The dir is underscore-prefixed so haumea treats it as private support
  # files instead of loading them as cell-block module options.)
  projectFiles = [
    ./_projects/zhongwen.nix
  ];
  projects = map (f: import f {inherit inputs;}) projectFiles;

  # Assemble the nginx document root: one folder per project.
  # There is no landing page; nginx autoindex lists the projects at "/".
  webroot = nixpkgs.runCommand "apps-webroot" {} ''
    mkdir -p $out
    ${lib.concatMapStringsSep "\n" (p: ''
        mkdir -p "$out/${p.name}"
        cp -rL --no-preserve=mode "${p.root}/." "$out/${p.name}/"'')
      projects}
  '';

  nginxConf = nixpkgs.writeText "apps-nginx.conf" ''
    server {
        listen 80;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            # Serve a project's index.html when present (e.g. /zhongwen/),
            # otherwise show the auto-generated directory listing (at /).
            autoindex on;
            try_files $uri $uri/ =404;
        }
    }
  '';

  dockerCompose = nixpkgs.writeTextFile {
    name = "apps-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      networks = {
        traefik_net = {external = true;};
      };
      services = {
        apps = {
          networks = ["default" "traefik_net"];
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.appsM1.compress=true"
            "traefik.http.middlewares.appsM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.appsM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.appsM2.headers.frameDeny=true"
            "traefik.http.middlewares.appsM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.appsM2.headers.stsSeconds=31536000"
            "traefik.http.routers.apps.entrypoints=https"
            "traefik.http.routers.apps.tls=true"
            "traefik.http.routers.apps.tls.certresolver=le-ssl"
            "traefik.http.routers.apps.middlewares=appsM1,appsM2"
            "traefik.http.routers.apps.rule=Host(`${domain}`)"
          ];
          image = "nginx:1.27-alpine";
          container_name = "apps";
          restart = "unless-stopped";
          volumes = [
            "${webroot}:/usr/share/nginx/html:ro"
            "${nginxConf}:/etc/nginx/conf.d/default.conf:ro"
          ];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-apps";
        text = ''
          echo "Composing apps"
          docker compose -p apps --file ${dockerCompose} up -d
        '';
      })
  ];
}
