#!/bin/bash
# OpenClaw Config Optimizer for AWS Production
# Date: 2026-03-29

echo "=========================================="
echo "OpenClaw Config Optimizer"
echo "=========================================="
echo ""

CONFIG_PATH="$HOME/.openclaw/openclaw.json"

# Check if config exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "❌ Config not found at $CONFIG_PATH"
    exit 1
fi

# Backup config
BACKUP_PATH="$HOME/.openclaw/openclaw.json.backup.$(date +%Y%m%d-%H%M%S)"
cp "$CONFIG_PATH" "$BACKUP_PATH"
echo "✓ Backup created: $BACKUP_PATH"
echo ""

echo "This script will optimize your OpenClaw config for:"
echo "  - AWS production environment"
echo "  - Telegram bot access"
echo "  - Better performance"
echo "  - Memory management"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "=== Applying Optimizations ==="
echo ""

# Create optimized config
cat > /tmp/openclaw-optimized.json <<'EOF'
{
  "agents": {
    "main": {
      "model": "anthropic/claude-opus-4-6",
      "thinking": "high",
      "temperature": 0.7,
      "maxTokens": 8192
    }
  },
  "providers": {
    "anthropic": {
      "apiKey": "REPLACE_WITH_YOUR_API_KEY"
    }
  },
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "lan",
    "cors": true,
    "rateLimit": {
      "enabled": true,
      "maxRequests": 100,
      "windowMs": 60000
    }
  },
  "messaging": {
    "telegram": {
      "enabled": true,
      "token": "REPLACE_WITH_YOUR_BOT_TOKEN",
      "allowedUsers": [123456789],
      "polling": true,
      "pollingInterval": 1000
    }
  },
  "memory": {
    "enabled": true,
    "type": "file",
    "maxSize": 10000,
    "ttl": 86400
  },
  "logging": {
    "level": "info",
    "file": true,
    "console": true
  },
  "skills": {
    "autoLoad": true,
    "paths": [
      "~/.openclaw/workspace/skills"
    ]
  },
  "performance": {
    "caching": true,
    "compression": true,
    "maxConcurrentRequests": 10
  }
}
EOF

# Merge with existing config (preserve API keys and tokens)
echo "Merging with existing config..."

# Extract sensitive data from current config
CURRENT_ANTHROPIC_KEY=$(jq -r '.providers.anthropic.apiKey // empty' "$CONFIG_PATH")
CURRENT_TELEGRAM_TOKEN=$(jq -r '.messaging.telegram.token // empty' "$CONFIG_PATH")
CURRENT_TELEGRAM_USERS=$(jq -r '.messaging.telegram.allowedUsers // []' "$CONFIG_PATH")

# Update optimized config with current sensitive data
if [ -n "$CURRENT_ANTHROPIC_KEY" ]; then
    jq ".providers.anthropic.apiKey = \"$CURRENT_ANTHROPIC_KEY\"" /tmp/openclaw-optimized.json > /tmp/openclaw-temp.json
    mv /tmp/openclaw-temp.json /tmp/openclaw-optimized.json
    echo "✓ Preserved Anthropic API key"
fi

if [ -n "$CURRENT_TELEGRAM_TOKEN" ]; then
    jq ".messaging.telegram.token = \"$CURRENT_TELEGRAM_TOKEN\"" /tmp/openclaw-optimized.json > /tmp/openclaw-temp.json
    mv /tmp/openclaw-temp.json /tmp/openclaw-optimized.json
    echo "✓ Preserved Telegram token"
fi

if [ "$CURRENT_TELEGRAM_USERS" != "[]" ] && [ "$CURRENT_TELEGRAM_USERS" != "null" ]; then
    jq ".messaging.telegram.allowedUsers = $CURRENT_TELEGRAM_USERS" /tmp/openclaw-optimized.json > /tmp/openclaw-temp.json
    mv /tmp/openclaw-temp.json /tmp/openclaw-optimized.json
    echo "✓ Preserved Telegram allowed users"
fi

# Apply optimized config
cp /tmp/openclaw-optimized.json "$CONFIG_PATH"
rm /tmp/openclaw-optimized.json

echo ""
echo "✓ Configuration optimized!"
echo ""

# Show what changed
echo "=== Optimizations Applied ==="
echo "✓ Gateway bind: lan (accessible from network)"
echo "✓ Main model: claude-opus-4-6"
echo "✓ Thinking level: high"
echo "✓ Memory: enabled (file-based)"
echo "✓ Rate limiting: enabled"
echo "✓ Caching: enabled"
echo "✓ Compression: enabled"
echo "✓ Skills auto-load: enabled"
echo ""

# Check if API key is set
ANTHROPIC_KEY=$(jq -r '.providers.anthropic.apiKey // empty' "$CONFIG_PATH")
TELEGRAM_TOKEN=$(jq -r '.messaging.telegram.token // empty' "$CONFIG_PATH")

echo "=== Configuration Status ==="
if [ -n "$ANTHROPIC_KEY" ] && [ "$ANTHROPIC_KEY" != "REPLACE_WITH_YOUR_API_KEY" ]; then
    echo "✓ Anthropic API key: SET"
else
    echo "⚠️  Anthropic API key: NOT SET"
    echo "   Edit config: nano ~/.openclaw/openclaw.json"
    echo "   Add your API key to: .providers.anthropic.apiKey"
fi

if [ -n "$TELEGRAM_TOKEN" ] && [ "$TELEGRAM_TOKEN" != "REPLACE_WITH_YOUR_BOT_TOKEN" ]; then
    echo "✓ Telegram token: SET"
else
    echo "⚠️  Telegram token: NOT SET"
    echo "   Edit config: nano ~/.openclaw/openclaw.json"
    echo "   Add your bot token to: .messaging.telegram.token"
fi

echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo ""
echo "1. Verify config:"
echo "   cat ~/.openclaw/openclaw.json | jq"
echo ""
echo "2. Restart gateway:"
echo "   openclaw gateway restart"
echo ""
echo "3. Check status:"
echo "   openclaw gateway status"
echo ""
echo "4. Test Telegram bot:"
echo "   Send message to your bot"
echo ""
echo "Backup saved at: $BACKUP_PATH"
echo "=========================================="
