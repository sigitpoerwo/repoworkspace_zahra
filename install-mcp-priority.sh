#!/bin/bash
# Install Priority MCP Servers for Zahra (Free)
# Priority: Brave Search > Filesystem > Memory

echo "=========================================="
echo "Installing Priority MCP Servers for Zahra"
echo "=========================================="
echo ""

# Check Node.js
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install Node.js first."
    exit 1
fi

echo "Installing MCP servers..."
echo ""

# Priority 1: Brave Search (Real-time research)
echo "1/3 Installing Brave Search MCP..."
npm install -g @modelcontextprotocol/server-brave-search
echo "✓ Brave Search installed"
echo ""

# Priority 2: Filesystem (Document management)
echo "2/3 Installing Filesystem MCP..."
npm install -g @modelcontextprotocol/server-filesystem
echo "✓ Filesystem installed"
echo ""

# Priority 3: Memory (Context retention)
echo "3/3 Installing Memory MCP..."
npm install -g @modelcontextprotocol/server-memory
echo "✓ Memory installed"
echo ""

# Create projects directory
mkdir -p ~/.openclaw/projects
mkdir -p ~/research
echo "✓ Created directories"
echo ""

# Backup config
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d-%H%M%S)
echo "✓ Config backed up"
echo ""

echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Get FREE Brave Search API key:"
echo "   https://brave.com/search/api/"
echo "   (2000 queries/month free)"
echo ""
echo "2. Add to config:"
echo "   nano ~/.openclaw/openclaw.json"
echo ""
echo "Add this section:"
cat <<'EOF'

  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "YOUR_BRAVE_API_KEY_HERE"
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
echo ""
echo "3. Restart gateway:"
echo "   openclaw gateway restart"
echo ""
echo "4. Test via Telegram:"
echo "   'Search latest research on digital transformation'"
echo "   'Save this to my research notes'"
echo ""
echo "=========================================="
echo "Zahra will have:"
echo "  🔍 Real-time web search (Brave)"
echo "  📁 File management (Filesystem)"
echo "  🧠 Context memory (Memory)"
echo "=========================================="
