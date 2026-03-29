# Setup Guide - Zahra Maurita Workspace

## Prerequisites

- OpenClaw 2026.3.24 or later
- Node.js 24.x or 22.14+
- Git
- AWS EC2 instance (for production deployment)

## Local Setup

### 1. Clone Repository

```bash
git clone https://github.com/sigitpoerwo/repoworkspace_zahra.git
cd joniaws-workspace
```

### 2. Install OpenClaw

```bash
# macOS/Linux
curl -fsSL https://openclaw.ai/install.sh | bash

# Windows PowerShell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

### 3. Setup OpenClaw

```bash
openclaw setup
```

### 4. Copy Workspace Files

```bash
# Copy identity files
cp IDENTITY.md SOUL.md AGENTS.md USER.md ~/.openclaw/workspace/

# Copy skills
cp -r skills ~/.openclaw/workspace/

# Copy memory structure
cp -r .ai ~/.openclaw/workspace/
```

### 5. Configure Your API Keys

Edit `~/.openclaw/openclaw.json` and add your API keys:

```json
{
  "agents": {
    "main": {
      "model": "your-provider/your-model",
      "thinking": "high"
    }
  },
  "providers": {
    "your-provider": {
      "apiKey": "YOUR_API_KEY_HERE"
    }
  }
}
```

### 6. Start Gateway

```bash
openclaw gateway start
```

### 7. Verify Setup

```bash
openclaw gateway status
```

## AWS Production Deployment

Follow the complete guide in `AWS_OPENCLAW_INSTALL_GUIDE.md` for:
- EC2 instance setup
- Security hardening (UFW, Fail2Ban)
- OpenClaw installation
- Telegram bot configuration
- Production optimization

## Telegram Bot Setup

### 1. Create Bot with BotFather

1. Open Telegram, search for `@BotFather`
2. Send `/newbot`
3. Follow instructions to get your bot token

### 2. Configure OpenClaw

Edit `~/.openclaw/openclaw.json`:

```json
{
  "messaging": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowedUsers": [YOUR_TELEGRAM_USER_ID]
    }
  }
}
```

### 3. Get Your Telegram User ID

Send a message to `@userinfobot` to get your user ID.

### 4. Restart Gateway

```bash
openclaw gateway restart
```

### 5. Test Bot

Send `/start` to your bot in Telegram.

## IDE Configuration

This workspace is pre-configured for multiple IDEs. Simply open the workspace in your preferred IDE:

- **Cursor**: Reads `.cursorrules`
- **Claude Code**: Reads `CLAUDE.md`
- **Codeium**: Reads `.codeiumrules`
- **GitHub Copilot**: Reads `.copilot-instructions.md`
- **Continue**: Reads `.continue/config.json`
- **Windsurf**: Reads `.windsurfrules`
- **Aider**: Reads `.aider.conf.yml`
- **VS Code**: Reads `.vscode/settings.json`

All IDEs will automatically recognize Zahra Maurita's identity and capabilities.

## Skills Management

### View Available Skills

```bash
openclaw skills list
```

### Enable Specific Skills

Skills are organized in categories:
- `01-SIAP-PAKAI` - Ready to use (200 skills)
- `02-PERLU-SETUP` - Requires setup (177 skills)
- `03-BELUM-DICOBA` - Untested (209 skills)
- `05-CUSTOM-SKILLS` - Custom built (67 skills)

### Add Custom Skills

```bash
# Create new skill
openclaw skills create my-custom-skill

# Edit skill
nano ~/.openclaw/workspace/skills/05-CUSTOM-SKILLS/my-custom-skill/SKILL.md
```

## Troubleshooting

### Gateway Won't Start

```bash
# Check logs
openclaw logs

# Run doctor
openclaw doctor --fix

# Check port availability
netstat -tulpn | grep 18789
```

### Telegram Bot Not Responding

```bash
# Check gateway status
openclaw gateway status

# Check logs
openclaw logs | grep telegram

# Verify token in config
cat ~/.openclaw/openclaw.json | grep token
```

### Skills Not Loading

```bash
# Verify skills directory
ls -la ~/.openclaw/workspace/skills/

# Check permissions
chmod -R 755 ~/.openclaw/workspace/skills/

# Restart gateway
openclaw gateway restart
```

## Updating

### Update OpenClaw

```bash
openclaw update
```

### Update Workspace

```bash
cd joniaws-workspace
git pull origin main
cp -r skills ~/.openclaw/workspace/
openclaw gateway restart
```

## Support

- **Documentation**: See `docs/` folder
- **AWS Guide**: `AWS_OPENCLAW_INSTALL_GUIDE.md`
- **Workspace Info**: `WORKSPACE_RECAP.md`
- **OpenClaw Docs**: https://docs.openclaw.ai

## Next Steps

1. ✅ Complete setup
2. ✅ Test gateway
3. ✅ Configure Telegram bot
4. ✅ Test skills
5. 🚀 Deploy to production (AWS)

---

**Ready to deploy!** 🦞
