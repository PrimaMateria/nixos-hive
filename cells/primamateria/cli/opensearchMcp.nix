# OpenSearch MCP server (opensearch-mcp-server-py) in multi-cluster mode.
#
# Provides an `opensearch-mcp` stdio server; register it with Claude Code once:
#   claude mcp add --scope user opensearch -- opensearch-mcp
# Clusters (URLs, credentials) live in secrets.wokwok.opensearch.clusters.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
  inherit (secrets.wokwok) opensearch;

  version = "0.12.0";

  configFile = (nixpkgs.formats.yaml {}).generate "opensearch-mcp-clusters.yml" {
    version = "1.0";
    description = "wokwok OpenSearch clusters";
    inherit (opensearch) clusters;
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "opensearch-mcp";
      text = ''
        # use nixpkgs python; uv-downloaded interpreters don't run on NixOS
        export UV_PYTHON=${nixpkgs.lib.getExe nixpkgs.python312}
        export UV_PYTHON_DOWNLOADS=never
        # manylinux wheels (numpy, ...) need these on NixOS
        export LD_LIBRARY_PATH=${nixpkgs.lib.makeLibraryPath [nixpkgs.stdenv.cc.cc.lib nixpkgs.zlib]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
        exec ${nixpkgs.uv}/bin/uvx opensearch-mcp-server-py@${version} \
          --mode multi \
          --config ${configFile} \
          "$@"
      '';
    })
  ];
}
