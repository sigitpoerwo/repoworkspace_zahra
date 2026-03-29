#!/bin/bash
# Safe Merge Script - Zahra Workspace to OpenClaw
# Version: 1.0
# Date: 2026-03-29

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Zahra Workspace Safe Merge ===${NC}"
echo ""

# Check if running on correct system
if [ ! -d ~/.openclaw ]; then
    echo -e "${RED}Error: OpenClaw not found. Please install OpenClaw first.${NC}"
    exit 1
fi

# Variables
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$HOME/openclaw-backup-$TIMESTAMP.tar.gz"
WORKSPACE="$HOME/.openclaw/workspace"
TEMP_DIR="/tmp/zahra-temp-$TIMESTAMP"
REPO_URL="https://github.com/sigitpoerwo/repoworkspace_zahra.git"

echo -e "${YELLOW}Step 1: Creating backup...${NC}"
cd ~
tar -czf "$BACKUP_FILE" .openclaw/
echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
echo ""

echo -e "${YELLOW}Step 2: Cloning Zahra workspace...${NC}"
git clone "$REPO_URL" "$TEMP_DIR"
echo -e "${GREEN}✓ Cloned to: $TEMP_DIR${NC}"
echo ""

echo -e "${YELLOW}Step 3: Backing up current skills...${NC}"
if [ -d "$WORKSPACE/skills" ]; then
    cp -r "$WORKSPACE/skills" "$WORKSPACE/skills-backup-$TIMESTAMP"
    echo -e "${GREEN}✓ Skills backed up${NC}"
else
    echo -e "${YELLOW}! No existing skills folder${NC}"
fi
echo ""

echo -e "${YELLOW}Step 4: Merging skills (safe mode)...${NC}"
if [ -d "$TEMP_DIR/skills" ]; then
    mkdir -p "$WORKSPACE/skills"
    rsync -av --ignore-existing "$TEMP_DIR/skills/" "$WORKSPACE/skills/"
    echo -e "${GREEN}✓ Skills merged (existing files preserved)${NC}"
fi
echo ""

echo -e "${YELLOW}Step 5: Adding new files...${NC}"

# Add GROWTH.md if not exists
if [ ! -f "$WORKSPACE/GROWTH.md" ]; then
    cp "$TEMP_DIR/GROWTH.md" "$WORKSPACE/" 2>/dev/null || true
    echo -e "${GREEN}✓ Added GROWTH.md${NC}"
fi

# Add IDE configs if not exist
for file in .cursorrules .editorconfig .antigravity.yml .clawconfig.txt .codeiumrules .copilot-instructions.md .clinerules .windsurfrules .aider.conf.yml; do
    if [ -f "$TEMP_DIR/$file" ] && [ ! -f "$WORKSPACE/$file" ]; then
        cp "$TEMP_DIR/$file" "$WORKSPACE/"
        echo -e "${GREEN}✓ Added $file${NC}"
    fi
done

# Add docs folder if not exists
if [ ! -d "$WORKSPACE/docs" ] && [ -d "$TEMP_DIR/docs" ]; then
    cp -r "$TEMP_DIR/docs" "$WORKSPACE/"
    echo -e "${GREEN}✓ Added docs/ folder${NC}"
fi

# Add .ai folder if not exists
if [ ! -d "$WORKSPACE/.ai" ] && [ -d "$TEMP_DIR/.ai" ]; then
    cp -r "$TEMP_DIR/.ai" "$WORKSPACE/"
    echo -e "${GREEN}✓ Added .ai/ folder${NC}"
fi

# Add .github folder if not exists
if [ ! -d "$WORKSPACE/.github" ] && [ -d "$TEMP_DIR/.github" ]; then
    cp -r "$TEMP_DIR/.github" "$WORKSPACE/"
    echo -e "${GREEN}✓ Added .github/ folder${NC}"
fi

# Add .vscode folder if not exists
if [ ! -d "$WORKSPACE/.vscode" ] && [ -d "$TEMP_DIR/.vscode" ]; then
    cp -r "$TEMP_DIR/.vscode" "$WORKSPACE/"
    echo -e "${GREEN}✓ Added .vscode/ folder${NC}"
fi

echo ""

echo -e "${YELLOW}Step 6: Identity files (optional)...${NC}"
echo -e "${YELLOW}Your existing IDENTITY.md, SOUL.md, AGENTS.md are PRESERVED.${NC}"
echo -e "${YELLOW}Zahra versions saved as *-ZAHRA.md for reference.${NC}"

# Save Zahra identity files for reference
cp "$TEMP_DIR/IDENTITY.md" "$WORKSPACE/IDENTITY-ZAHRA.md" 2>/dev/null || true
cp "$TEMP_DIR/SOUL.md" "$WORKSPACE/SOUL-ZAHRA.md" 2>/dev/null || true
cp "$TEMP_DIR/AGENTS.md" "$WORKSPACE/AGENTS-ZAHRA.md" 2>/dev/null || true

echo -e "${GREEN}✓ Zahra identity files saved as reference${NC}"
echo ""

echo -e "${YELLOW}Step 7: Cleanup...${NC}"
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✓ Temporary files removed${NC}"
echo ""

echo -e "${YELLOW}Step 8: Restarting gateway...${NC}"
openclaw gateway restart
sleep 3
echo -e "${GREEN}✓ Gateway restarted${NC}"
echo ""

echo -e "${GREEN}=== Merge Complete! ===${NC}"
echo ""
echo -e "${GREEN}Summary:${NC}"
echo "  • Backup: $BACKUP_FILE"
echo "  • Skills: Merged (existing preserved)"
echo "  • New files: Added"
echo "  • Identity: Yours preserved (Zahra saved as *-ZAHRA.md)"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Test gateway: openclaw gateway status"
echo "  2. List skills: openclaw skills list"
echo "  3. Test bot: Send message to Telegram bot"
echo ""
echo -e "${YELLOW}To use Zahra identity (optional):${NC}"
echo "  cp $WORKSPACE/IDENTITY-ZAHRA.md $WORKSPACE/IDENTITY.md"
echo "  cp $WORKSPACE/SOUL-ZAHRA.md $WORKSPACE/SOUL.md"
echo "  cp $WORKSPACE/AGENTS-ZAHRA.md $WORKSPACE/AGENTS.md"
echo "  openclaw gateway restart"
echo ""
echo -e "${YELLOW}To rollback:${NC}"
echo "  openclaw gateway stop"
echo "  cd ~ && tar -xzf $BACKUP_FILE"
echo "  openclaw gateway start"
echo ""
echo -e "${GREEN}Done! 🦞${NC}"
