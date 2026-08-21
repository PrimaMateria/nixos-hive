{inputs}: {
  # URL path / folder name under the shared host: https://apps.../kpop-game/
  name = "kpop-game";
  # No-build static game: serve the repo source tree directly.
  # Asset paths are relative, so it works under /kpop-game/ unchanged.
  root = inputs.kpop-game;
}
