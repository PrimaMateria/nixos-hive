{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  home.packages = with nixpkgs; [
    enpass
    gnome.simple-scan
    flameshot
    qimgv
    libreoffice
    gimp
  ];


  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "l";
      "move_right" = "h";
      "move_visual_mark_up" = "<S-k>";
      "move_visual_mark_down" = "<S-j>";
      "enter_visual_mark_mode" = "v";
    };

    config = {
      search_url_g = "https://duckduckgo.com/?q=";
      search_url_t = "https://translate.google.com/?sl=auto&tl=en&op=translate&text=";
      search_url_m = "https://www.google.com/maps/search/?api=1&query=";
      search_url_i = "https://duckduckgo.com/?iax=images&ia=images&q=";
      search_url_w = "https://en.wikipedia.org/wiki/Special:Search?go=Go&search=";
      search_url_d = "https://www.wortbedeutung.info/?query=";
      search_url_e = "https://www.dictionary.com/browse/";
      ruler_mode = "1";
    };
  };
}
