{inputs}: {
  # URL path / folder name under the shared host: https://apps.../zhongwen/
  name = "zhongwen";
  # Served folder: the built static site produced by the zhongwen flake.
  # Built with a relative base, so it works under /zhongwen/ unchanged.
  root = inputs.zhongwen.packages.${inputs.nixpkgs.stdenv.hostPlatform.system}.default;
}
