# Safe Merge Guide - Zahra Workspace to Existing OpenClaw

## Overview

This guide ensures you can merge Zahra Maurita workspace into your existing OpenClaw installation **WITHOUT losing any data**.

## Pre-Merge Checklist

Before merging, verify your current workspace:

```bash
# Check current workspace
cd ~/.openclaw/workspace
ls -la

# Check gateway status
openclaw gateway status

# Backup current workspace
cd ~
tar -czf openclaw-backup-$(date +%Y%m%d-%H%M%S).tar.gz .openclaw/
echo "Backup created: openclaw-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
```

## Merge Strategy

### What Will Be Preserved

✅ **Your existing files:**
- IDENTITY.md (your current identity)
- SOUL.md (your current personality)
- AGENTS.md (your current agent config)
- USER.md (your user profile)
- All custom projects (AutoResearchClaw, etc.)
- All threads templates
- All memory files
- All configs

✅ **Your existing folders:**
- AutoResearchClaw/
- memory/
- projects/
- configs/
- archives/
- notes/
- tasks/

### What Will Be Added

✅ **New from Zahra workspace:**
- 663 skills (merged with existing skills)
- GROWTH.md (learning system)
- IDE configuration files
- Additional documentation
- .ai/ folder (AI memory structure)
- docs/ folder (reference docs)

### What Will Be Updated (Optional)

⚠️ **You decide:**
- IDENTITY.md - Keep yours OR upgrade to Zahra Maurita
- SOUL.md - Keep yours OR use Zahra's personality
- AGENTS.md - Keep yours OR use Zahra's multi-agent setup

## Step-by-Step Merge

### Step 1: Backup Everything

```bash
# Full backup
cd ~
tar -czf openclaw-full-backup-$(date +%Y%m%d-%H%M%S).tar.gz .openclaw/

# Verify backup
ls -lh openclaw-full-backup-*.tar.gz
```

### Step 2: Clone Zahra Workspace to Temp

```bash
# Clone to temporary location
cd /tmp
git clone https://github.com/sigitpoerwo/repoworkspace_zahra.git zahra-temp
cd zahra-temp
ls -la
```

### Step 3: Merge Skills (Safe)

```bash
# Merge skills without overwriting
cd ~/.openclaw/workspace

# Create skills backup
cp -r skills skills-backup-$(date +%Y%m%d)

# Merge Zahra skills
rsync -av --ignore-existing /tmp/zahra-temp/skills/ ./skills/

# Verify
ls -la skills/
```

### Step 4: Add New Files Only

```bash
# Copy only files that don't exist
cd ~/.openclaw/workspace

# Add GROWTH.md if not exists
if [ ! -f GROWTH.md ]; then
  cp /tmp/zahra-temp/GROWTH.md .
fi

# Add IDE configs if not exists
if [ ! -f .cursorrules ]; then
  cp /tmp/zahra-temp/.cursorrules .
fi

# Add docs folder if not exists
if [ ! -d docs ]; then
  cp -r /tmp/zahra-temp/docs .
fi

# Add .ai folder if not exists
if [ ! -d .ai ]; then
  cp -r /tmp/zahra-temp/.ai .
fi
```

### Step 5: Optional - Upgrade Identity

**Option A: Keep Your Current Identity**
```bash
# Do nothing - your IDENTITY.md stays as is
echo "Keeping current identity"
```

**Option B: Upgrade to Zahra Maurita**
```bash
# Backup current identity
cp IDENTITY.md IDENTITY.md.backup

# Use Zahra identity
cp /tmp/zahra-temp/IDENTITY.md .

# Review changes
diff IDENTITY.md.backup IDENTITY.md
```

**Option C: Merge Both Identities**
```bash
# Keep both for reference
cp /tmp/zahra-temp/IDENTITY.md IDENTITY-ZAHRA.md

# Manually merge later
nano IDENTITY.md
```

### Step 6: Cleanup

```bash
# Remove temp files
rm -rf /tmp/zahra-temp

# Verify workspace
cd ~/.openclaw/workspace
ls -la
```

### Step 7: Restart Gateway

```bash
# Restart to load new skills
openclaw gateway restart

# Verify status
openclaw gateway status

# Check logs
openclaw logs | tail -20
```

## Verification

### Check Skills Loaded

```bash
# List all skills
openclaw skills list

# Should show both old and new skills
```

### Check Identity

```bash
# View current identity
cat ~/.openclaw/workspace/IDENTITY.md
```

### Test Gateway

```bash
# Test locally
curl http://localhost:18789/health

# Test Telegram bot
# Send message to your bot - should respond
```

## Rollback (If Needed)

### Full Rollback

```bash
# Stop gateway
openclaw gateway stop

# Restore from backup
cd ~
tar -xzf openclaw-full-backup-TIMESTAMP.tar.gz

# Restart gateway
openclaw gateway start
```

### Partial Rollback (Skills Only)

```bash
# Restore skills only
cd ~/.openclaw/workspace
rm -rf skills
mv skills-backup-TIMESTAMP skills

# Restart gateway
openclaw gateway restart
```

## Merge Comparison

### Before Merge

```
~/.openclaw/workspace/
├── IDENTITY.md (yours)
├── SOUL.md (yours)
├── AGENTS.md (yours)
├── AutoResearchClaw/
├── skills/ (your existing skills)
├── memory/
├── projects/
└── threads-*.md
```

### After Merge

```
~/.openclaw/workspace/
├── IDENTITY.md (yours - preserved)
├── SOUL.md (yours - preserved)
├── AGENTS.md (yours - preserved)
├── GROWTH.md (new - added)
├── AutoResearchClaw/ (yours - preserved)
├── skills/ (merged - old + new)
│   ├── 01-SIAP-PAKAI/ (200 new skills)
│   ├── 02-PERLU-SETUP/ (177 new skills)
│   ├── 03-BELUM-DICOBA/ (209 new skills)
│   └── 05-CUSTOM-SKILLS/ (67 new skills)
├── docs/ (new - added)
├── .ai/ (new - added)
├── memory/ (yours - preserved)
├── projects/ (yours - preserved)
└── threads-*.md (yours - preserved)
```

## Troubleshooting

### Skills Not Loading

```bash
# Check permissions
chmod -R 755 ~/.openclaw/workspace/skills/

# Restart gateway
openclaw gateway restart
```

### Gateway Won't Start

```bash
# Check logs
openclaw logs

# Run doctor
openclaw doctor --fix
```

### Identity Conflict

```bash
# View current identity
cat ~/.openclaw/workspace/IDENTITY.md

# Compare with Zahra
cat /tmp/zahra-temp/IDENTITY.md

# Choose which to use
```

## Best Practices

1. **Always backup before merge**
2. **Test in stages** (skills first, then docs, then identity)
3. **Keep your existing identity** unless you want full Zahra upgrade
4. **Verify after each step**
5. **Don't rush** - merge can be done incrementally

## Support

If merge fails or you need help:
1. Check logs: `openclaw logs`
2. Restore backup: `tar -xzf openclaw-full-backup-*.tar.gz`
3. Review this guide again
4. Check OpenClaw docs: https://docs.openclaw.ai

---

**Merge Time:** ~10 minutes
**Risk Level:** Low (with backup)
**Reversible:** Yes (with backup)
**Last Updated:** 2026-03-29
