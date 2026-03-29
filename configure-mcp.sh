#!/bin/bash
# Configure MCP Servers for Zahra (After Installation)
# Run this after install-mcp-priority.sh

echo "=========================================="
echo "Configure MCP Servers for Zahra"
echo "=========================================="
echo ""

CONFIG="$HOME/.openclaw/openclaw.json"

# Check if MCP servers are installed
echo "Checking MCP installations..."
if ! npm list -g @modelcontextprotocol/server-brave-search &> /dev/null; then
    echo "❌ MCP servers not installed. Run install-mcp-priority.sh first."
    exit 1
fi
echo "✓ MCP servers found"
echo ""

# Backup config
cp "$CONFIG" "$CONFIG.backup.$(date +%Y%m%d-%H%M%S)"
echo "✓ Config backed up"
echo ""

# Check if Brave API key is provided
echo "=========================================="
echo "Brave Search API Key Setup"
echo "=========================================="
echo ""
echo "Get FREE API key: https://brave.com/search/api/"
echo "(2000 queries/month free)"
echo ""
read -p "Enter Brave API key (or press Enter to skip): " BRAVE_KEY
echo ""

# Add MCP config using jq
if command -v jq &> /dev/null; then
    echo "Adding MCP servers to config..."

    # Create MCP config
    MCP_CONFIG='{
      "mcpServers": {
        "filesystem": {
          "command": "npx",
          "args": [
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "/home/ubuntu/.openclaw/projects",
            "/home/ubuntu/research"
          ]
        },
        "memory": {
          "command": "npx",
          "args": ["-y", "@modelcontextprotocol/server-memory"]
        }
      }
    }'

    # Add Brave if key provided
    if [ -n "$BRAVE_KEY" ]; then
        MCP_CONFIG=$(echo "$MCP_CONFIG" | jq --arg key "$BRAVE_KEY" '
          .mcpServers["brave-search"] = {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-brave-search"],
            "env": {
              "BRAVE_API_KEY": $key
            }
          }
        ')
    fi

    # Merge with existing config
    jq ". + $MCP_CONFIG" "$CONFIG" > /tmp/openclaw-mcp.json
    mv /tmp/openclaw-mcp.json "$CONFIG"

    echo "✓ MCP servers configured"
else
    echo "⚠️  jq not found. Manual config needed."
    echo ""
    echo "Add this to ~/.openclaw/openclaw.json:"
    cat <<EOF
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "$BRAVE_KEY"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/ubuntu/.openclaw/projects",
        "/home/ubuntu/research"
      ]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
EOF
fi

echo ""
echo "=========================================="
echo "Restarting Gateway"
echo "=========================================="
openclaw gateway restart

echo ""
echo "=========================================="
echo "✓ MCP Configuration Complete!"
echo "=========================================="
echo ""
echo "Zahra now has:"
if [ -n "$BRAVE_KEY" ]; then
    echo "  🔍 Brave Search - Real-time research"
fi
echo "  📁 Filesystem - Document management"
echo "  🧠 Memory - Context retention"
echo ""
echo "Test via Telegram @joniaws_bot:"
if [ -n "$BRAVE_KEY" ]; then
    echo "  'Search latest research on digital transformation'"
fi
echo "  'Save this to my research folder'"
echo "  'Remember my research focus is e-commerce'"
echo ""
echo "=========================================="
