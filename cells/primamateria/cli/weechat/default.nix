{ cell, inputs }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
  inherit (nixpkgs) lib;

  theme = import ./__theme.nix;

  channels = [
    "#java"
    "#javascript"
    "#typescript"
    "#linux"
    "#archlinux"
    "#archlinux-newbie"
    "#gaminigonlinux"
    "#react"
    "#i3"
    "##programming"
    "##electronics"
    "#neovim"
    "#nixos"
    "#xeserv"
  ];
in
{
  home.packages = [
    (nixpkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        scripts = with nixpkgs.weechatScripts; [
          weechat-matrix
          weechat-autosort
          weechat-go
        ];
        init =
          theme +
          secrets.weechat +
          ''
            /set irc.look.smart_filter on
            /filter add irc_smart * irc_smart_filter *
            /set irc.look.server_buffer independent
            /mouse enable

            /server add libera irc.libera.chat
            /set irc.server.libera.addresses "irc.libera.chat/6697"
            /set irc.server.libera.ssl on
            /set irc.server.libera.autoconnect on
            /set irc.server.libera.autojoin "${lib.concatStringsSep "," channels}"

            /matrix connect matrix_org
            /set matrix.server.matrix_org.autoconnect on

            /set script.scripts.download_enabled on
            /script install emoji.lua

            /key bind meta-j /go
          '';
      };
    })
  ];
}
