{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.home-manager.lib) hm;
  inherit (cell) secrets;

  slack-mcp-server = nixpkgs.buildGoModule {
    pname = "slack-mcp-server";
    version = "1.3.0";
    src = nixpkgs.fetchFromGitHub {
      owner = "korotovsky";
      repo = "slack-mcp-server";
      rev = "v1.3.0";
      hash = "sha256-I4f6yKV0BXtaxnqi/XNID+Pwl2mWjSqxIHhb07U7sc4=";
    };
    vendorHash = "sha256-Kv9mDjWicruh+9hDJ4NEtvDhCqw0iwuJedJmk8HOcHY=";
    doCheck = false;
  };
in {
  home.packages = [slack-mcp-server];

  home.activation.claudeMcpSlack = hm.dag.entryAfter ["writeBoundary"] ''
    # claude mcp add --scope user writes to ~/.claude.json, not ~/.claude/settings.json
    db="$HOME/.claude.json"
    if [ ! -f "$db" ]; then
      echo '{}' > "$db"
    fi
    tmp=$(mktemp)
    ${nixpkgs.jq}/bin/jq \
      --arg cmd "${slack-mcp-server}/bin/slack-mcp-server" \
      --arg xoxcToken "${secrets.slack.xoxcToken}" \
      --arg xoxdCookie "${secrets.slack.xoxdCookie}" \
      '.mcpServers.slack = {"command": $cmd, "args": ["--no-cache"], "env": {"SLACK_MCP_XOXC_TOKEN": $xoxcToken, "SLACK_MCP_XOXD_TOKEN": $xoxdCookie}}' \
      "$db" > "$tmp" && mv "$tmp" "$db"
  '';
}
