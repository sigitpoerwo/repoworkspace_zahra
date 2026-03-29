#!/bin/bash
# OpenClaw Config Checker & Optimizer for AWS
# Date: 2026-03-29

echo "=========================================="
echo "OpenClaw Config Checker & Optimizer"
echo "=========================================="
echo ""

CONFIG_PATH="$HOME/.openclaw/openclaw.json"

# Check if config exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "❌ Config not found at $CONFIG_PATH"
    exit 1
fi

echo "✓ Config found: $CONFIG_PATH"
echo ""

# Backup config
BACKUP_PATH="$HOME/.openclaw/openclaw.json.backup.$(date +%Y%m%d-%H%M%S)"
cp "$CONFIG_PATH" "$BACKUP_PATH"
echo "✓ Backup created: $BACKUP_PATH"
echo ""

# Display current config (hide sensitive data)
echo "=== Current Configuration ==="
cat "$CONFIG_PATH" | jq -r '
  # Hide API keys
  walk(
    if type == "object" then
      with_entries(
        if .key | test("apiKey|token|secret|password"; "i") then
          .value = "***HIDDEN***"
        else
          .
        end
      )
    else
      .
    end
  )
' 2>/dev/null || cat "$CONFIG_PATH"

echo ""
echo "=========================================="
echo "Configuration Analysis"
echo "=========================================="
echo ""

# Check gateway settings
echo "=== Gateway Settings ==="
GATEWAY_MODE=$(jq -r '.gateway.mode // "not set"' "$CONFIG_PATH")
GATEWAY_PORT=$(jq -r '.gateway.port // "not set"' "$CONFIG_PATH")
GATEWAY_BIND=$(jq -r '.gateway.bind // "not set"' "$CONFIG_PATH")

echo "Mode: $GATEWAY_MODE"
echo "Port: $GATEWAY_PORT"
echo "Bind: $GATEWAY_BIND"

if [ "$GATEWAY_BIND" == "loopback" ] || [ "$GATEWAY_BIND" == "127.0.0.1" ]; then
    echo "⚠️  Gateway is loopback-only (not accessible from Telegram)"
    echo "   Recommendation: Change to 'lan' or '0.0.0.0' for Telegram bot"
fi
echo ""

# Check agents configuration
echo "=== Agents Configuration ==="
MAIN_MODEL=$(jq -r '.agents.main.model // "not set"' "$CONFIG_PATH")
MAIN_THINKING=$(jq -r '.agents.main.thinking // "not set"' "$CONFIG_PATH")

echo "Main model: $MAIN_MODEL"
echo "Thinking level: $MAIN_THINKING"

if [ "$MAIN_MODEL" == "not set" ] || [ "$MAIN_MODEL" == "null" ]; then
    echo "⚠️  No main model configured"
fi
echo ""

# Check providers
echo "=== Providers ==="
PROVIDERS=$(jq -r '.providers | keys[]' "$CONFIG_PATH" 2>/dev/null)
if [ -z "$PROVIDERS" ]; then
    echo "⚠️  No providers configured"
else
    echo "Configured providers:"
    for provider in $PROVIDERS; do
        HAS_KEY=$(jq -r ".providers.$provider.apiKey // empty" "$CONFIG_PATH")
        if [ -n "$HAS_KEY" ]; then
            echo "  ✓ $provider (API key set)"
        else
            echo "  ⚠️  $provider (no API key)"
        fi
    done
fi
echo ""

# Check messaging (Telegram)
echo "=== Messaging (Telegram) ==="
TELEGRAM_ENABLED=$(jq -r '.messaging.telegram.enabled // false' "$CONFIG_PATH")
TELEGRAM_TOKEN=$(jq -r '.messaging.telegram.token // empty' "$CONFIG_PATH")
TELEGRAM_USERS=$(jq -r '.messaging.telegram.allowedUsers // [] | length' "$CONFIG_PATH")

echo "Enabled: $TELEGRAM_ENABLED"
if [ -n "$TELEGRAM_TOKEN" ]; then
    echo "Token: ***SET***"
else
    echo "Token: ⚠️  NOT SET"
fi
echo "Allowed users: $TELEGRAM_USERS"

if [ "$TELEGRAM_ENABLED" == "true" ] && [ -z "$TELEGRAM_TOKEN" ]; then
    echo "⚠️  Telegram enabled but no token configured"
fi
echo ""

# Check memory settings
echo "=== Memory Settings ==="
MEMORY_ENABLED=$(jq -r '.memory.enabled // "not set"' "$CONFIG_PATH")
MEMORY_TYPE=$(jq -r '.memory.type // "not set"' "$CONFIG_PATH")

echo "Enabled: $MEMORY_ENABLED"
echo "Type: $MEMORY_TYPE"
echo ""

# Check logging
echo "=== Logging ==="
LOG_LEVEL=$(jq -r '.logging.level // "not set"' "$CONFIG_PATH")
echo "Level: $LOG_LEVEL"
echo ""

# Recommendations
echo "=========================================="
echo "Optimization Recommendations"
echo "=========================================="
echo ""

RECOMMENDATIONS=()

# Gateway bind recommendation
if [ "$GATEWAY_BIND" == "loopback" ] || [ "$GATEWAY_BIND" == "127.0.0.1" ]; then
    RECOMMENDATIONS+=("1. Change gateway.bind to 'lan' for Telegram bot access")
fi

# Model recommendation
if [ "$MAIN_MODEL" == "not set" ] || [ "$MAIN_MODEL" == "null" ]; then
    RECOMMENDATIONS+=("2. Configure main agent model (e.g., anthropic/claude-opus-4-6)")
fi

# Telegram recommendation
if [ "$TELEGRAM_ENABLED" == "true" ] && [ -z "$TELEGRAM_TOKEN" ]; then
    RECOMMENDATIONS+=("3. Add Telegram bot token")
fi

# Thinking level recommendation
if [ "$MAIN_THINKING" == "not set" ] || [ "$MAIN_THINKING" == "null" ]; then
    RECOMMENDATIONS+=("4. Set thinking level (low/medium/high)")
fi

# Memory recommendation
if [ "$MEMORY_ENABLED" == "not set" ] || [ "$MEMORY_ENABLED" == "false" ]; then
    RECOMMENDATIONS+=("5. Enable memory for better context retention")
fi

if [ ${#RECOMMENDATIONS[@]} -eq 0 ]; then
    echo "✓ Configuration looks good!"
else
    echo "Found ${#RECOMMENDATIONS[@]} recommendations:"
    for rec in "${RECOMMENDATIONS[@]}"; do
        echo "  $rec"
    done
fi

echo ""
echo "=========================================="
echo "Optimization Script"
echo "=========================================="
echo ""
echo "To apply optimizations, run:"
echo "  bash openclaw-optimize.sh"
echo ""
echo "Or manually edit:"
echo "  nano ~/.openclaw/openclaw.json"
echo ""
echo "After changes, restart gateway:"
echo "  openclaw gateway restart"
echo "=========================================="
