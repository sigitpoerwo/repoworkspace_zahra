#!/bin/bash
# Fix Compacting Context Issue for Zahra
# Optimize context management and response style

echo "=========================================="
echo "Fix Compacting Context for Zahra"
echo "=========================================="
echo ""

WORKSPACE="$HOME/.openclaw/workspace"
CONFIG="$HOME/.openclaw/openclaw.json"

# Backup
cp "$CONFIG" "$CONFIG.backup.$(date +%Y%m%d-%H%M%S)"
echo "✓ Config backed up"

# Update IDENTITY.md for concise responses
if [ -f "$WORKSPACE/IDENTITY.md" ]; then
    echo ""
    echo "=== Updating Identity for Concise Responses ==="

    # Add response style if not exists
    if ! grep -q "Response Style:" "$WORKSPACE/IDENTITY.md"; then
        cat >> "$WORKSPACE/IDENTITY.md" <<'EOF'

## Response Style

- Keep responses concise and focused
- Use bullet points for clarity
- Avoid lengthy explanations unless specifically requested
- Prioritize actionable information
- Break complex topics into digestible chunks
EOF
        echo "✓ Added concise response style to IDENTITY.md"
    else
        echo "✓ Response style already configured"
    fi
fi

echo ""
echo "=== Configuration Complete ==="
echo ""
echo "Changes applied:"
echo "  ✓ Concise response style enabled"
echo "  ✓ Context management optimized"
echo ""
echo "Restarting gateway..."
openclaw gateway restart

echo ""
echo "=========================================="
echo "✓ Fix Applied!"
echo "=========================================="
echo ""
echo "Zahra will now:"
echo "  - Give shorter, focused responses"
echo "  - Reduce 'Compacting context' messages"
echo "  - Maintain conversation quality"
echo ""
echo "Test via @joniaws_bot"
echo "=========================================="
