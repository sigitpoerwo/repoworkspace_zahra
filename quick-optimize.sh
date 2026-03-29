#!/bin/bash
# Quick Config Optimization for Joni
# Add memory, performance, and projects separation

CONFIG_PATH="$HOME/.openclaw/openclaw.json"

echo "=========================================="
echo "Quick Config Optimization for Joni"
echo "=========================================="
echo ""

# Backup
cp "$CONFIG_PATH" "$CONFIG_PATH.backup.$(date +%Y%m%d-%H%M%S)"
echo "✓ Backup created"

# Add optimizations using jq
jq '. + {
  "memory": {
    "enabled": true,
    "type": "file",
    "maxSize": 10000,
    "ttl": 86400
  },
  "performance": {
    "caching": true,
    "compression": true,
    "maxConcurrentRequests": 10
  },
  "projects": {
    "path": "~/.openclaw/projects",
    "autoCreate": true
  },
  "logging": {
    "level": "info",
    "file": true,
    "console": true
  }
}' "$CONFIG_PATH" > /tmp/openclaw-optimized.json

# Apply
mv /tmp/openclaw-optimized.json "$CONFIG_PATH"

echo "✓ Optimizations applied:"
echo "  - Memory: enabled (file-based, 10K max)"
echo "  - Performance: caching + compression"
echo "  - Projects: separate folder"
echo "  - Logging: info level"
echo ""

# Create projects folder
mkdir -p ~/.openclaw/projects
echo "✓ Projects folder created"
echo ""

# Restart gateway
echo "Restarting gateway..."
openclaw gateway restart

echo ""
echo "=========================================="
echo "✓ Optimization Complete!"
echo "=========================================="
echo ""
echo "Joni sekarang:"
echo "  🚀 Lebih cepat (caching enabled)"
echo "  🧠 Lebih cerdas (memory enabled)"
echo "  💾 Ingat conversation (10K history)"
echo "  📁 Projects terpisah dari workspace"
echo ""
echo "Test via Telegram: @joniaws_bot"
echo "=========================================="
