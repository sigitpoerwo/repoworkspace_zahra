#!/bin/bash
# Switch Identity from Joni to Zahra Maurita
# Date: 2026-03-29

echo "=========================================="
echo "Switch Identity: Joni → Zahra Maurita"
echo "=========================================="
echo ""

WORKSPACE="$HOME/.openclaw/workspace"

# Check if Zahra identity exists
if [ ! -f "$WORKSPACE/IDENTITY-ZAHRA.md" ]; then
    echo "❌ IDENTITY-ZAHRA.md not found!"
    echo "Please ensure Zahra workspace is merged first."
    exit 1
fi

echo "This will replace current identity with Zahra Maurita:"
echo "  - Name: Zahra Maurita"
echo "  - Role: AI Chief Digital Officer"
echo "  - Expertise: 8 Digital Domains"
echo "  - Focus: Research & Academic Assistant"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "=== Switching Identity ==="
echo ""

# Backup current identity
if [ -f "$WORKSPACE/IDENTITY.md" ]; then
    cp "$WORKSPACE/IDENTITY.md" "$WORKSPACE/IDENTITY-JONI-BACKUP.md"
    echo "✓ Backed up current identity to IDENTITY-JONI-BACKUP.md"
fi

# Replace with Zahra identity
cp "$WORKSPACE/IDENTITY-ZAHRA.md" "$WORKSPACE/IDENTITY.md"
echo "✓ Identity switched to Zahra Maurita"

# Also update SOUL and AGENTS if available
if [ -f "$WORKSPACE/SOUL-ZAHRA.md" ]; then
    if [ -f "$WORKSPACE/SOUL.md" ]; then
        cp "$WORKSPACE/SOUL.md" "$WORKSPACE/SOUL-JONI-BACKUP.md"
    fi
    cp "$WORKSPACE/SOUL-ZAHRA.md" "$WORKSPACE/SOUL.md"
    echo "✓ Soul updated to Zahra personality"
fi

if [ -f "$WORKSPACE/AGENTS-ZAHRA.md" ]; then
    if [ -f "$WORKSPACE/AGENTS.md" ]; then
        cp "$WORKSPACE/AGENTS.md" "$WORKSPACE/AGENTS-JONI-BACKUP.md"
    fi
    cp "$WORKSPACE/AGENTS-ZAHRA.md" "$WORKSPACE/AGENTS.md"
    echo "✓ Agents config updated to Zahra setup"
fi

echo ""
echo "=== Restarting Gateway ==="
openclaw gateway restart

echo ""
echo "=========================================="
echo "✓ Identity Switch Complete!"
echo "=========================================="
echo ""
echo "Zahra Maurita is now active:"
echo "  🎓 AI Chief Digital Officer"
echo "  📚 8 Digital Domains Expert"
echo "  🔬 Academic Research Assistant"
echo "  💼 Management & Digital Business Focus"
echo ""
echo "Test via Telegram: @joniaws_bot"
echo "(Bot will now respond as Zahra Maurita)"
echo ""
echo "To revert back to Joni:"
echo "  cp $WORKSPACE/IDENTITY-JONI-BACKUP.md $WORKSPACE/IDENTITY.md"
echo "  openclaw gateway restart"
echo "=========================================="
