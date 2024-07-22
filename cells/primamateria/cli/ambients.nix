{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  ambients-sync = nixpkgs.writeShellApplication {
    name = "ambients-sync";
    runtimeInputs = with nixpkgs; [yt-dlp ffmpeg];
    text = ''
      mkdir -p ~/Music/ambients/

      yt-dlp -P ~/Music/ambients/ \
        -o '%(playlist_index)02d - %(title)s.%(ext)s' \
        -x --audio-format mp3 --audio-qualit 10 \
        --no-overwrites \
        https://www.youtube.com/playlist?list=PLjDqZb1FVlst1XPXongf5UD02yU9Md-ot
    '';
  };
in {
  home.packages =
    (with nixpkgs; [
      cmus
      mpv
    ])
    ++ [ambients-sync];
}
