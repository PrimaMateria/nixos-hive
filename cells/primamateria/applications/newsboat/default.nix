{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "\"firefox '%u' > /dev/null 2>&1\"";
    maxItems = 50;
    urls = import ./__urls.nix;

    extraConfig = ''
      include ${nixpkgs.newsboat}/share/doc/newsboat/contrib/colorschemes/solarized-dark

      # unbind keys
      unbind-key ENTER
      unbind-key j
      unbind-key k
      unbind-key J
      unbind-key K

      # bind keys - vim style
      bind-key j down
      bind-key k up
      bind-key l open
      bind-key h quit

      # highlights
      highlight article "^(Title):.*$" blue default
      highlight article "https?://[^ ]+" red default
      highlight article "\\[image\\ [0-9]+\\]" green default
    '';
  };
}
