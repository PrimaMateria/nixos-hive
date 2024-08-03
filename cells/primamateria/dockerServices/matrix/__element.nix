{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  elementConfiguration = nixpkgs.writeTextFile {
    name = "element-config.json";
    text = builtins.toJSON {
      # TODO
      default_server_config = {
        "m.homeserver" = {
          base_url = "https://matrix.primamateria.ddns.net";
          server_name = "matrix.primamateria.ddns.net";
        };
        "m.identity_server" = {
          base_url = "https://vector.im";
        };
      };
      brand = "Element";
      integrations_ui_url = "https://scalar.vector.im/";
      integrations_rest_url = "https://scalar.vector.im/api";
      integrations_widgets_urls = [
        "https://scalar.vector.im/_matrix/integrations/v1"
        "https://scalar.vector.im/api"
        "https://scalar-staging.vector.im/_matrix/integrations/v1"
        "https://scalar-staging.vector.im/api"
        "https://scalar-staging.riot.im/scalar/api"
      ];
      hosting_signup_link = "https://element.io/matrix-services?utm_source=element-web&utm_medium=web";

      uisi_autorageshake_app = "element-auto-uisi";
      showLabsSettings = true;
      piwik = {
        url = "https://piwik.riot.im/";
        siteId = 1;
        policyUrl = "https://element.io/cookie-policy";
      };
      roomDirectory = {
        servers = [
          "matrix.org"
          "gitter.im"
          "libera.chat"
        ];
      };
      enable_presence_by_hs_url = {
        "https://matrix.org" = false;
        "https://matrix-client.matrix.org" = false;
      };
      terms_and_conditions_links = [
        {
          url = "https://element.io/privacy";
          text = "Privacy Policy";
        }
        {
          url = "https://element.io/cookie-policy";
          text = "Cookie Policy";
        }
      ];
      hostSignup = {
        brand = "Element Home";
        cookiePolicyUrl = "https://element.io/cookie-policy";
        domains = [
          "matrix.org"
        ];
        privacyPolicyUrl = "https://element.io/privacy";
        termsOfServiceUrl = "https://element.io/terms-of-service";
        url = "https://ems.element.io/element-home/in-app-loader";
      };
      sentry = {
        dsn = "https://029a0eb289f942508ae0fb17935bd8c5@sentry.matrix.org/6";
        environment = "develop";
      };
      posthog = {
        projectApiKey = "phc_Jzsm6DTm6V2705zeU5dcNvQDlonOR68XvX2sh1sEOHO";
        apiHost = "https://posthog.hss.element.io";
      };
      features = {};
      map_style_url = "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx";
    };
  };
in {
  element = {
    image = "vectorim/element-web:latest";
    container_name = "element";
    restart = "unless-stopped";
    volumes = [
      "${elementConfiguration}:/app/config.json:ro"
    ];
    environment = [
      "BASE_URL=/element"
      "PUBLIC_URL=/element"
    ];
    labels = [
      "traefik.enable=true"

      "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
      "traefik.http.middlewares.https_redirect.redirectscheme.permanent=true"
      "traefik.http.routers.http-element.entrypoints=http"
      "traefik.http.routers.http-element.rule=Host(`element.primamateria.ddns.net`)"
      "traefik.http.routers.http-element.middlewares=https_redirect"

      "traefik.http.middlewares.element_stripprefix.stripprefix.prefixes=element"
      "traefik.http.routers.https-element.entrypoints=https"
      "traefik.http.routers.https-element.rule=Host(`element.primamateria.ddns.net`)"
      "traefik.http.routers.https-element.middlewares=element_stripprefix"
      "traefik.http.routers.https-element.tls=true"
      "traefik.http.routers.https-element.tls.certresolver=le-ssl"
      "traefik.http.routers.https-element.service=element"
      "traefik.http.services.element.loadbalancer.server.port=80"
    ];
  };
}
