{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
in
{
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "newsboat";
        text = ''
          # This for avoiding duplicated when using remote RSS server
          # rm "$HOME/.local/share/newsboat/cache.db"
          # curl '${secrets.freshrss.host}/i/?c=feed&a=actualize&user=${secrets.freshrss.user}&token=${secrets.freshrss.token}'
          ${nixpkgs.newsboat}/bin/newsboat
        '';
      })
  ];

  xdg.configFile."newsboat/config".text = ''
    max-items 50
    browser "firefox '%u' > /dev/null 2>&1"
    reload-threads 5
    auto-reload yes
    reload-time 60
    prepopulate-query-feeds yes

    include ${nixpkgs.newsboat}/share/doc/newsboat/contrib/colorschemes/solarized-dark

    # unbind keys
    unbind-key ENTER
    unbind-key j
    unbind-key k
    unbind-key J
    unbind-key K
    unbind-key n
    unbind-key o

    # bind keys - vim style
    bind-key j down
    bind-key k up
    bind-key l open
    bind-key h quit
    bind-key n toggle-article-read
    bind-key o open-in-browser-and-mark-read

    # highlights
    highlight article "^(Title):.*$" cyan default
    highlight article "https?://[^ ]+" red default
    highlight article "\\[image\\ [0-9]+\\]" green default

    # remote
    urls-source "freshrss"
    freshrss-url "${secrets.freshrss.host}/api/greader.php"
    freshrss-login "${secrets.freshrss.user}"
    freshrss-password "${secrets.freshrss.password}"

  '';
}
